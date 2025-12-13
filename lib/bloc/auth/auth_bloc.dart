import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    on<LoginRequestedEvent>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequestedEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    // Simulate a delay for authentication process
    await Future.delayed(Duration(seconds: 2));
    // After successful authentication
    emit(AuthenticatedState(username: event.username));
  }
}