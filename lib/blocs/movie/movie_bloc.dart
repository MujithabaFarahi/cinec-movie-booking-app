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
    on<GetShowtimesByMovieId>(_onGetShowtimesByMovieId);
  }

  Future<void> _onGetUserById(
    GetUserById event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final query = databaseMethods.getUserById(event.id);

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final user = UserModel.fromFirestore(data!);

        emit(state.copyWith(isLoading: false, user: user));
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
      final query = databaseMethods.getAllMovies();

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
}
