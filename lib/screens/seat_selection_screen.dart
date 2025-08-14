import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/custom_alert.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String showTimeId;
  final String movieId;
  final int ticketCount;
  final double ticketPrice;
  const SeatSelectionScreen({
    super.key,
    required this.showTimeId,
    required this.movieId,
    required this.ticketCount,
    required this.ticketPrice,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  void _confirmBooking() async {
    if (selectedSeats.isEmpty) {
      CoreUtils.toastError("Please select seats.");
      return;
    } else if (selectedSeats.length != widget.ticketCount) {
      CoreUtils.toastError("Please select ${widget.ticketCount} seats.");
      return;
    }

    final userId = context.read<MovieBloc>().state.user!.id;
    final DateTime showDateTime = context
        .read<MovieBloc>()
        .state
        .showtime!
        .dateTime;

    final showtimeRef = FirebaseFirestore.instance
        .collection("movies")
        .doc(movie.id)
        .collection("showtimes")
        .doc(widget.showTimeId);

    final bookingRef = FirebaseFirestore.instance.collection("bookings").doc();

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(showtimeRef);

        if (!snapshot.exists) {
          throw Exception("Showtime not found");
        }

        List<String> booked = List<String>.from(
          snapshot.get("bookedSeats") ?? [],
        );

        // Check for duplicates
        for (var seat in selectedSeats) {
          if (booked.contains(seat)) {
            throw Exception("Seat $seat has already been booked");
          }
        }

        // Update bookedSeats atomically
        booked.addAll(selectedSeats);
        transaction.update(showtimeRef, {"bookedSeats": booked});

        // Save booking document under user
        transaction.set(bookingRef, {
          "userId": userId,
          "movieId": movie.id,
          "movieTitle": movie.title,
          "posterUrl": movie.posterUrl,
          "showTimeId": widget.showTimeId,
          "showDateTime": showDateTime.toIso8601String(),
          "seats": selectedSeats,
          "bookedAt": DateTime.now().toIso8601String(),
        });
      });

      CoreUtils.toastSuccess("Booking confirmed!");
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/bookings',
          (route) => false,
        );
      }
    } catch (e) {
      CoreUtils.toastError(e.toString());
    }
  }

  final int rows = 9;
  final int columns = 10;
  List<String> selectedSeats = [];
  List<String> bookedSeats = [];
  late MovieModel movie;

  @override
  void initState() {
    super.initState();

    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movie = movieBloc.state.movie!;

    movieBloc.add(
      GetShowTimeById(id: widget.showTimeId, movieId: widget.movieId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${movie.title} - Seats',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state.isLoading && state.showtime == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final showtime = state.showtime;
            bookedSeats = showtime?.bookedSeats ?? [];

            return Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Screen This Way",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 5,
                  width: double.infinity,
                  color: Colors.grey[400],
                ),

                _buildLegend(),

                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: 1,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: rows * columns,
                  itemBuilder: (context, index) {
                    String seatLabel = _seatLabel(index);
                    bool isBooked = bookedSeats.contains(seatLabel);
                    bool isSelected = selectedSeats.contains(seatLabel);

                    return GestureDetector(
                      onTap: isBooked
                          ? () {
                              setState(() {
                                if (isSelected) {
                                  selectedSeats.remove(seatLabel);
                                }
                              });
                            }
                          : () {
                              setState(() {
                                if (isSelected) {
                                  selectedSeats.remove(seatLabel);
                                } else {
                                  int remaining =
                                      widget.ticketCount - selectedSeats.length;
                                  if (remaining <= 0) {
                                    // CoreUtils.toastError(
                                    //   'Reached the ticket Count',
                                    // );
                                    HapticFeedback.heavyImpact();
                                    return;
                                  }

                                  String row = seatLabel[0];

                                  // Seats already selected in this row
                                  List<String> rowSelectedSeats = selectedSeats
                                      .where((s) => s[0] == row)
                                      .toList();

                                  int clickedCol = int.parse(
                                    seatLabel.substring(1),
                                  );

                                  List<int> candidateCols = [];

                                  // If nothing selected in row, just start with clicked seat
                                  if (rowSelectedSeats.isEmpty) {
                                    candidateCols.add(clickedCol);
                                  } else {
                                    // Find nearest block(s)
                                    rowSelectedSeats.sort(
                                      (a, b) => int.parse(
                                        a.substring(1),
                                      ).compareTo(int.parse(b.substring(1))),
                                    );

                                    // Check left expansion
                                    int minCol = int.parse(
                                      rowSelectedSeats.first.substring(1),
                                    );
                                    int maxCol = int.parse(
                                      rowSelectedSeats.last.substring(1),
                                    );

                                    if (clickedCol < minCol) {
                                      for (
                                        int c = clickedCol;
                                        c <= minCol - 1;
                                        c++
                                      ) {
                                        candidateCols.add(c);
                                      }
                                    } else if (clickedCol > maxCol) {
                                      for (
                                        int c = maxCol + 1;
                                        c <= clickedCol;
                                        c++
                                      ) {
                                        candidateCols.add(c);
                                      }
                                    } else {
                                      // Clicked inside a gap or existing block, just add this seat
                                      candidateCols.add(clickedCol);
                                    }
                                  }

                                  // Add seats until ticketCount is reached, skipping booked/selected
                                  for (int col in candidateCols) {
                                    String seat = "$row$col";
                                    if (!bookedSeats.contains(seat) &&
                                        !selectedSeats.contains(seat) &&
                                        selectedSeats.length <
                                            widget.ticketCount) {
                                      selectedSeats.add(seat);
                                    }
                                  }
                                }
                                HapticFeedback.selectionClick();
                              });
                            },

                      child: Container(
                        decoration: BoxDecoration(
                          color: isBooked
                              ? isSelected
                                    ? AppColors.danger500
                                    : AppColors.alizarin400
                              : isSelected
                              ? AppColors.success400
                              : AppColors.gray300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            seatLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: isBooked ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Text(
                    selectedSeats.isEmpty
                        ? "No seats selected"
                        : "Selected: ${selectedSeats.join(', ')}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 20),
                selectedSeats.length == widget.ticketCount
                    ? SizedBox.shrink()
                    : Text(
                        'Select ${widget.ticketCount - selectedSeats.length} more seat(s)',
                      ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: PrimaryButton(
          text: 'Confirm',
          disabled: selectedSeats.length != widget.ticketCount,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlert(
                  iconPath: 'assets/icons/logout.png',
                  title: 'Confirm Purchase',
                  message:
                      'Are you sure you want to confirm your purchase of ${widget.ticketCount} tickets at a total cost of ${widget.ticketCount * widget.ticketPrice} LKR?',
                  onConfirm: _confirmBooking,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        _legendItem(AppColors.gray300, "Available"),
        _legendItem(AppColors.success400, "Selected"),
        _legendItem(AppColors.alizarin400, "Booked"),
        _legendItem(AppColors.danger500, "Not Available"),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String _seatLabel(int index) {
    int row = index ~/ columns;
    int col = index % columns + 1;
    String rowLetter = String.fromCharCode(65 + row);
    return "$rowLetter$col";
  }
}
