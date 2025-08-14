part of 'movie_bloc.dart';

class MovieState extends Equatable {
  final bool isLoading;
  final bool isLoading2;
  final bool isError;
  final bool isSuccess;
  final bool isAdmin;
  final String? message;
  final UserModel? user;
  final List<MovieModel> allMovies;
  final List<MovieModel> movies;
  final MovieModel? movie;
  final List<ShowtimeModel> showtimes;
  final ShowtimeModel? showtime;
  final double? defaultTicketPrice;
  final List<BookingModel> bookings;
  final BookingModel? booking;

  const MovieState({
    this.isLoading = false,
    this.isLoading2 = false,
    this.isError = false,
    this.isSuccess = false,
    this.isAdmin = false,
    this.message,
    this.user,
    this.allMovies = const [],
    this.movies = const [],
    this.movie,
    this.showtimes = const [],
    this.showtime,
    this.defaultTicketPrice = 400,
    this.bookings = const [],
    this.booking,
  });

  factory MovieState.initial() {
    return const MovieState(
      isLoading: false,
      isLoading2: false,
      isError: false,
      isSuccess: false,
      isAdmin: false,
      message: null,
      user: null,
      allMovies: [],
      movies: [],
      movie: null,
      showtimes: [],
      showtime: null,
      defaultTicketPrice: 400,
      bookings: [],
      booking: null,
    );
  }

  MovieState copyWith({
    bool? isLoading,
    bool? isLoading2,
    bool? isError,
    bool? isSuccess,
    bool? isAdmin,
    String? message,
    UserModel? user,
    List<UserModel>? users,
    List<MovieModel>? allMovies,
    List<MovieModel>? movies,
    MovieModel? movie,
    List<ShowtimeModel>? showtimes,
    ShowtimeModel? showtime,
    double? defaultTicketPrice,
    List<BookingModel>? bookings,
    BookingModel? booking,
  }) {
    return MovieState(
      isLoading: isLoading ?? this.isLoading,
      isLoading2: isLoading2 ?? this.isLoading2,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      isAdmin: isAdmin ?? this.isAdmin,
      message: message ?? this.message,
      user: user ?? this.user,
      allMovies: allMovies ?? this.allMovies,
      movies: movies ?? this.movies,
      movie: movie ?? this.movie,
      showtimes: showtimes ?? this.showtimes,
      showtime: showtime ?? this.showtime,
      defaultTicketPrice: defaultTicketPrice ?? this.defaultTicketPrice,
      bookings: bookings ?? this.bookings,
      booking: booking ?? this.booking,
    );
  }

  @override
  List<Object?> get props => [
    message,
    isLoading,
    isLoading2,
    isError,
    isSuccess,
    isAdmin,
    user,
    movies,
    movie,
    showtimes,
    showtime,
    defaultTicketPrice,
    bookings,
    booking,
  ];
}
