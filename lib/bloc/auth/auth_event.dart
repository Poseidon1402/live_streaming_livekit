part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String username;

  LoginRequestedEvent({required this.username});
}