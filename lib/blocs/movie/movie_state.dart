part of 'movie_bloc.dart';

class MovieState extends Equatable {
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isError;
  final bool isSuccess;
  final String? message;
  final UserModel? user;
  final List<MovieModel> movies;
  final List<ShowtimeModel> showtimes;

  const MovieState({
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isError = false,
    this.isSuccess = false,
    this.message,
    this.user,
    this.movies = const [],
    this.showtimes = const [],
  });

  MovieState copyWith({
    bool? isLoading,
    bool? isGoogleLoading,
    bool? isError,
    bool? isSuccess,
    String? message,
    UserModel? user,
    List<UserModel>? users,
    List<MovieModel>? movies,
    List<ShowtimeModel>? showtimes,
  }) {
    return MovieState(
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      user: user ?? this.user,
      movies: movies ?? this.movies,
      showtimes: showtimes ?? this.showtimes,
    );
  }

  @override
  List<Object?> get props => [
    message,
    isLoading,
    isGoogleLoading,
    isError,
    isSuccess,
    user,
    movies,
    showtimes,
  ];
}
