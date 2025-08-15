import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/Models/showtime_model.dart';
import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/cached_image.dart';
import 'package:cinec_movies/widgets/custom_switch.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cinec_movies/widgets/showtime_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieViewScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieViewScreen({super.key, required this.movie});

  @override
  State<MovieViewScreen> createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends State<MovieViewScreen> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();

    final movieBloc = BlocProvider.of<MovieBloc>(context);
    isAdmin = movieBloc.state.isAdmin;
    movieBloc.add(GetMovieById(widget.movie.id));
    movieBloc.add(GetShowtimesByMovieId(widget.movie.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.movie.title,
        showBackButton: true,
        onIconPressed: isAdmin
            ? () {
                Navigator.pushNamed(
                  context,
                  '/add-movie',
                  arguments: {'isEditMode': true},
                );
              }
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state.isLoading && state.movie == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.isError &&
                    !state.isLoading &&
                    state.movie == null) {
                  return Center(
                    child: Text('Error loading movie: ${state.message}'),
                  );
                } else if (state.movie == null) {
                  return Center(child: Text('No movie found.'));
                } else if (state.movie != null) {
                  final movie = state.movie!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: CachedImage(url: movie.posterUrl),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              Text(
                                '${movie.genre} • ${movie.duration} min',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          state.isAdmin
                              ? CustomSwitchButton(
                                  value: movie.nowShowing,
                                  onChanged: (value) {
                                    final movieBloc =
                                        BlocProvider.of<MovieBloc>(context);
                                    movieBloc.add(
                                      UpdateMovieStatusById(movie.id, value),
                                    );
                                  },
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Text(
                        movie.synopsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Showtimes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state.isLoading && state.showtimes.isEmpty) {
                  final showtimes = List.generate(
                    6,
                    (index) => ShowtimeModel(
                      id: '${index + 1}',
                      dateTime: DateTime.now(),
                      bookedSeats: [],
                      ticketPrice: 400,
                    ),
                  );

                  return Wrap(
                    runSpacing: 6,
                    children: showtimes.map((showtime) {
                      return ShowtimeWidget(
                        isLoading: true,
                        dateTime: showtime.dateTime,
                      );
                    }).toList(),
                  );
                }

                if (state.isError &&
                    !state.isLoading &&
                    state.showtimes.isEmpty) {
                  return Text('Error loading showtimes: ${state.message}');
                }

                if (state.showtimes.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const Text('No shows available at the moment.'),
                      ],
                    ),
                  );
                } else {
                  final showtimes = state.showtimes;

                  return Wrap(
                    runSpacing: 6,
                    children: showtimes.map((showtime) {
                      return ShowtimeWidget(
                        dateTime: showtime.dateTime,
                        onTap: () {
                          _showTicketCountDialog(
                            context,
                            showtime.id,
                            400,
                            80 - showtime.bookedSeats.length,
                            widget.movie.id,
                          );
                        },
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.isAdmin) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: PrimaryButton(
                text: 'Add ShowTime',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/add-showtime',
                    arguments: {'movieId': widget.movie.id},
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

void _showTicketCountDialog(
  BuildContext context,
  String showTimeId,
  double price,
  int max,
  String movieId,
) {
  int ticketCount = 1;

  int availableTickets = max < 10 ? max : 10;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Tickets",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                // Ticket selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: ticketCount > 1
                          ? () => setState(() => ticketCount--)
                          : null,
                    ),
                    Text(
                      ticketCount.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),

                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: ticketCount < availableTickets
                          ? () => setState(() => ticketCount++)
                          : null,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price display
                Text(
                  "Total: LKR ${(ticketCount * price).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                PrimaryButton(
                  text: 'Continue to Seat Selection',
                  onPressed: () {
                    Navigator.pop(context); // close modal

                    Navigator.pushNamed(
                      context,
                      '/seat-selection',
                      arguments: {
                        'showTimeId': showTimeId,
                        'movieId': movieId,
                        'ticketCount': ticketCount,
                        'ticketPrice': price,
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}
