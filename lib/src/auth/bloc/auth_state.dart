part of 'auth_bloc.dart';

class AuthState {
  AuthState({
    this.authStatus = AuthStatus.initial,
    this.signInWithEmailStatus = const StatusInitial(),
    this.createWithEmailStatus = const StatusInitial(),
    this.agent = const Agent(),
  });

  final AuthStatus authStatus;
  final Status signInWithEmailStatus;
  final Status createWithEmailStatus;
  final Agent agent;

  AuthState copyWith({
    AuthStatus? authStatus,
    Status? signInWithEmailStatus,
    Status? createWithEmailStatus,
    Agent? agent,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      signInWithEmailStatus:
          signInWithEmailStatus ?? this.signInWithEmailStatus,
      createWithEmailStatus:
          createWithEmailStatus ?? this.createWithEmailStatus,
      agent: agent ?? this.agent,
    );
  }
}
