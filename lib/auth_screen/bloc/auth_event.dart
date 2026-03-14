part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
    final String fullName;
    final String email;
    final String password;


  const AuthRegisterRequested(this.fullName ,this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class GoogleSighInRequested extends AuthEvent {}

class AuthSighoutRequested extends AuthEvent {}