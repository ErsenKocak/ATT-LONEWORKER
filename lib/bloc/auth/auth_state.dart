part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {
  final AuthResponse authResponse;

  AuthLoadedState(this.authResponse);
}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);
}
