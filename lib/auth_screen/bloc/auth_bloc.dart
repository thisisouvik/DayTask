import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:daytask/auth_screen/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<AuthLoginRequested>(_onAuthLogin);
    on<AuthRegisterRequested>(_onAuthRegister);
    on<GoogleSighInRequested>(_onGoogleSignIn);
    on<AuthSighoutRequested>(_onAuthSignOut);
  }

  FutureOr<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user.id));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      final user = authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user.id));
      } else {
        emit(const AuthError('Failed to retrieve user data after login.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> _onAuthRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signUpWithEmail(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      final user = authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user.id));
      } else {
        emit(
          const AuthError('Failed to retrieve user data after registration.'),
        );
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> _onGoogleSignIn(
    GoogleSighInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signInWithGoogle();
      final user = authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user.id));
      } else {
        emit(const AuthError('Waiting to Google sign-in.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> _onAuthSignOut(
    AuthSighoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
