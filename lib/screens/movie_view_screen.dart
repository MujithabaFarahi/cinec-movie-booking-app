import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/cached_image.dart';
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
  @override
  void initState() {
    super.initState();

    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movieBloc.add(GetMovieById(widget.movie.id));
    movieBloc.add(GetShowtimesByMovieId(widget.movie.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.movie.title, showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: CachedImage(url: movie.posterUrl),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '${movie.genre} • ${movie.duration} min',
                        style: Theme.of(context).textTheme.titleSmall,
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
                  return Center(child: CircularProgressIndicator());
                } else if (state.isError && !state.isLoading) {
                  return Text('Error loading showtimes: ${state.message}');
                } else if (state.showtimes.isEmpty) {
                  return const Text('No showtimes available.');
                } else {
                  final showtimes = state.showtimes;

                  return Column(
                    children: showtimes.map((showtime) {
                      return ShowtimeWidget(
                        dateTime: showtime.dateTime,
                        onTap: () {
                          _showTicketCountDialog(
                            context,
                            showtime.id,
                            400,
                            80 - showtime.bookedSeats.length,
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
    );
  }
}

void _showTicketCountDialog(
  BuildContext context,
  String showTimeId,
  double price,
  int max,
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
                        'ticketCount': ticketCount,
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
