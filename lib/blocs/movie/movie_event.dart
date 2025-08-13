part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();
}

final class GetUserById extends MovieEvent {
  final String id;

  const GetUserById(this.id);

  @override
  List<Object?> get props => [id];
}

final class GetAllMovies extends MovieEvent {
  const GetAllMovies();

  @override
  List<Object?> get props => [];
}

final class GetShowtimesByMovieId extends MovieEvent {
  final String movieId;

  const GetShowtimesByMovieId(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
