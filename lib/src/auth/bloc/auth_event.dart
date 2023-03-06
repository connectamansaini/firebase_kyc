part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class IsAuthenticated extends AuthEvent {}

class SignedInWithEmailAndPassword extends AuthEvent {
  SignedInWithEmailAndPassword(this.email, this.password);

  final String email;
  final String password;
}

class CreatedUserWithEmailAndPassword extends AuthEvent {
  CreatedUserWithEmailAndPassword(this.email, this.password);

  final String email;
  final String password;
}

class SignedOut extends AuthEvent {}
