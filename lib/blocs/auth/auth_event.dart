part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class GetUserById extends AuthEvent {
  final String id;

  const GetUserById(this.id);

  @override
  List<Object?> get props => [id];
}
