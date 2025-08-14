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
  final bool isAdmin;
  const GetAllMovies({this.isAdmin = false});

  @override
  List<Object?> get props => [isAdmin];
}

final class GetMovieById extends MovieEvent {
  final String id;

  const GetMovieById(this.id);

  @override
  List<Object?> get props => [id];
}

final class UpdateMovieStatusById extends MovieEvent {
  final String id;
  final bool nowShowing;

  const UpdateMovieStatusById(this.id, this.nowShowing);

  @override
  List<Object?> get props => [id, nowShowing];
}

final class GetShowtimesByMovieId extends MovieEvent {
  final String movieId;

  const GetShowtimesByMovieId(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

final class GetShowTimeById extends MovieEvent {
  final String id;
  final String movieId;

  const GetShowTimeById({required this.id, required this.movieId});

  @override
  List<Object?> get props => [id, movieId];
}

final class GetAllBookings extends MovieEvent {
  const GetAllBookings();

  @override
  List<Object?> get props => [];
}

final class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

final class ResetState extends MovieEvent {
  const ResetState();

  @override
  List<Object?> get props => [];
}
