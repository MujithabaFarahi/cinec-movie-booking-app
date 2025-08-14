import 'package:cinec_movies/Models/booking_model.dart';
import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/Models/showtime_model.dart';
import 'package:cinec_movies/Models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinec_movies/services/database.dart';
import 'package:equatable/equatable.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final DatabaseMethods databaseMethods;

  MovieBloc(this.databaseMethods) : super(const MovieState()) {
    on<GetUserById>(_onGetUserById);
    on<GetAllMovies>(_onGetAllMovies);
    on<GetMovieById>(_onGetMovieById);
    on<UpdateMovieStatusById>(_onUpdateMovieStatusById);
    on<GetShowtimesByMovieId>(_onGetShowtimesByMovieId);
    on<GetShowTimeById>(_onGetShowTimeById);
    on<GetAllBookings>(_onGetAllBookings);
  }

  Future<void> _onGetUserById(
    GetUserById event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final query = databaseMethods.getUserById(event.id);

      bool isAdmin = false;

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final user = UserModel.fromFirestore(data!, documentSnapshot.id);

        if (user.email == 'admin@gmail.com') {
          isAdmin = true;
        }

        add(GetAllMovies(isAdmin: isAdmin));

        emit(state.copyWith(isLoading: false, user: user, isAdmin: isAdmin));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, message: e.toString()),
      );
    }
  }

  Future<void> _onGetAllMovies(
    GetAllMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final query = databaseMethods.getAllMovies(isAdmin: state.isAdmin);

      await for (final querySnapshot in query) {
        final movies = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return MovieModel.fromFirestore(data, doc.id);
        }).toList();

        emit(state.copyWith(isLoading: false, movies: movies));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, message: e.toString()),
      );
    }
  }

  Future<void> _onGetMovieById(
    GetMovieById event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, movie: null));

    try {
      final query = databaseMethods.getMovieById(event.id);

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final movie = MovieModel.fromFirestore(data!, documentSnapshot.id);

        emit(state.copyWith(isLoading: false, movie: movie));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, message: e.toString()),
      );
    }
  }

  Future<void> _onUpdateMovieStatusById(
    UpdateMovieStatusById event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading2: true));

    try {
      await databaseMethods.updateMovieStatusById(event.id, event.nowShowing);
      final movie = state.movies.firstWhere((m) => m.id == event.id);

      emit(state.copyWith(isLoading2: false, movie: movie));
    } catch (e) {
      emit(
        state.copyWith(isLoading2: false, isError: true, message: e.toString()),
      );
    }
  }

  Future<void> _onGetShowtimesByMovieId(
    GetShowtimesByMovieId event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final query = databaseMethods.getShowtimesByMovieId(event.movieId);

      await for (final querySnapshot in query) {
        final showtimes = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ShowtimeModel.fromFirestore(data, doc.id);
        }).toList();

        emit(state.copyWith(isLoading: false, showtimes: showtimes));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, message: e.toString()),
      );
    }
  }

  Future<void> _onGetShowTimeById(
    GetShowTimeById event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, showtime: null));

    try {
      final query = databaseMethods.getShowtimeByMovieAndId(
        event.movieId,
        event.id,
      );

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final showTime = ShowtimeModel.fromFirestore(
          data!,
          documentSnapshot.id,
        );

        emit(state.copyWith(isLoading: false, showtime: showTime));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, message: e.toString()),
      );
    }
  }

  Future<void> _onGetAllBookings(
    GetAllBookings event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final query = databaseMethods.getAllBookings(
        isAdmin: state.isAdmin,
        userId: state.user?.id ?? '',
      );

      await for (final querySnapshot in query) {
        final bookings = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return BookingModel.fromFirestore(data, doc.id);
        }).toList();

        emit(state.copyWith(isLoading: false, bookings: bookings));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isError: true, message: e.toString()),
      );
    }
  }
}
