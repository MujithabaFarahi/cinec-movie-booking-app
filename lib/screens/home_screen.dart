import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/theme/media_query_extension.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/movie_card.dart';
import 'package:cinec_movies/widgets/primary_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final movieBloc = BlocProvider.of<MovieBloc>(context);

    movieBloc.add(GetAllMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home Screen'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PrimaryTextfield(
              hintText: 'Search movies...',
              onChanged: (value) {
                BlocProvider.of<MovieBloc>(context).add(SearchMovies(value));
              },
              svgIconPath: 'assets/icons/search.svg',
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state.isLoading && state.movies.isEmpty) {
                  return GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (context.screenWidth / 150).floor(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final movie = MovieModel(
                        id: '',
                        title: 'title',
                        genre: 'genre',
                        duration: 100,
                        synopsis: 'synopsis',
                        posterUrl: 'posterUrl',
                        createdAt: DateTime.now(),
                        nowShowing: true,
                      );
                      return MovieCard(
                        isLoading: true,
                        movie: movie,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/movie',
                            arguments: {'movie': movie},
                          );
                        },
                      );
                    },
                  );
                } else if (state.isError && !state.isLoading) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state.movies.isEmpty && !state.isLoading) {
                  return const Center(
                    child: Text('No movies currently showing.'),
                  );
                } else {
                  final movies = state.movies;

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: movies.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (context.screenWidth / 150).floor(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/movie',
                            arguments: {'movie': movie},
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.isAdmin) {
            return FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                Navigator.pushNamed(context, '/add-movie');
              },
              child: const Icon(Icons.add, color: AppColors.white),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      // bottomNavigationBar: BlocBuilder<MovieBloc, MovieState>(
      //   builder: (context, state) {
      //     if (state.isAdmin) {
      //       return Padding(
      //         padding: const EdgeInsets.only(
      //           left: 20.0,
      //           right: 20.0,
      //           top: 20.0,
      //         ),
      //         child: PrimaryButton(
      //           text: 'Add Movie',
      //           height: 40,
      //           onPressed: () {
      //             Navigator.pushNamed(context, '/add-movie');
      //           },
      //         ),
      //       );
      //     }
      //     return const SizedBox.shrink();
      //   },
      // ),
    );
  }
}
