part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isError;
  final String? message;
  final User? user;
  final List<User> users;

  const AuthState({
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isError = false,
    this.message,
    this.user,
    this.users = const [],
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isGoogleLoading,
    bool? isError,
    String? message,
    User? user,
    List<User>? users,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      user: user ?? this.user,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [
    message,
    isLoading,
    isGoogleLoading,
    isError,
    user,
    users,
  ];
}
