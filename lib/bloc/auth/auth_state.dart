part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class AuthenticatedState extends AuthState {
  final String username;

  AuthenticatedState({required this.username});

  @override
  List<Object?> get props => [username];
}

