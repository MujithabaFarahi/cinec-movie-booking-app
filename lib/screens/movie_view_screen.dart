import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/cached_image.dart';
import 'package:cinec_movies/widgets/showtime_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    movieBloc.add(GetShowtimesByMovieId(widget.movie.id));
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: CustomAppBar(title: movie.title, showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: CachedImage(url: movie.posterUrl),
            ),

            const SizedBox(height: 16),
            Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
            Text(
              '${movie.genre} • ${movie.duration} min',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Text(movie.synopsis, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            const Text(
              'Showtimes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

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
                          Navigator.pushNamed(
                            context,
                            '/seat-selection',
                            arguments: {'movie': movie, 'showtime': showtime},
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
