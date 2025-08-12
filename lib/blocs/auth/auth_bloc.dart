import 'package:cinec_movies/Models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinec_movies/services/database.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DatabaseMethods databaseMethods;

  AuthBloc(this.databaseMethods) : super(const AuthState()) {
    on<GetUserById>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final query = databaseMethods.getUserById(event.id);

        await for (final documentSnapshot in query) {
          final data = documentSnapshot.data();
          final user = User.fromMap(data!);
          emit(state.copyWith(isLoading: false, user: user));
        }
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            message: e.toString(),
          ),
        );
      }
    });
  }
}
