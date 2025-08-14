import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String showTimeId;
  final int ticketCount;
  const SeatSelectionScreen({
    super.key,
    required this.showTimeId,
    required this.ticketCount,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final int rows = 9;
  final int columns = 10;
  List<String> selectedSeats = [];
  List<String> bookedSeats = [];
  late MovieModel movie;

  @override
  void initState() {
    super.initState();

    final movieBloc = BlocProvider.of<MovieBloc>(context);
    bookedSeats = movieBloc.state.showtimes
        .firstWhere((showtime) => showtime.id == widget.showTimeId)
        .bookedSeats;

    print(
      movieBloc.state.showtimes
          .firstWhere((showtime) => showtime.id == widget.showTimeId)
          .bookedSeats,
    );
    movie = movieBloc.state.movie!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${movie.title} - Seats',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Screen This Way",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
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
                      ? null
                      : () {
                          setState(() {
                            if (isSelected) {
                              selectedSeats.remove(seatLabel);
                            } else {
                              int remaining =
                                  widget.ticketCount - selectedSeats.length;
                              if (remaining <= 0) {
                                CoreUtils.toastError(
                                  'Reached the ticket Count',
                                );
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
                                    selectedSeats.length < widget.ticketCount) {
                                  selectedSeats.add(seat);
                                }
                              }
                            }
                          });
                        },

                  child: Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? AppColors.alizarin400
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
            Text(
              'Select ${widget.ticketCount - selectedSeats.length} more seats',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedSeats.isEmpty
                    ? "No seats selected"
                    : "Selected: ${selectedSeats.join(', ')}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            PrimaryButton(text: 'Confirm', onPressed: () {}, width: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(AppColors.gray300!, "Available"),
        const SizedBox(width: 16),
        _legendItem(AppColors.success400, "Selected"),
        const SizedBox(width: 16),
        _legendItem(AppColors.alizarin400!, "Booked"),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
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
    );
  }

  String _seatLabel(int index) {
    int row = index ~/ columns;
    int col = index % columns + 1;
    String rowLetter = String.fromCharCode(65 + row);
    return "$rowLetter$col";
  }
}
