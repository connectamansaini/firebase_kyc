import 'package:bloc/bloc.dart';
import 'package:firebase_kyc/src/agent/models/agent.dart';
import 'package:firebase_kyc/src/auth/repository/auth_repository.dart';
import 'package:firebase_kyc/src/core/domain/enums.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(AuthState()) {
    on<IsAuthenticated>(_onIsAuthenticated);
    on<SignedInWithEmailAndPassword>(_onSignedInWithEmailAndPassword);
    on<CreatedUserWithEmailAndPassword>(_onCreatedUserWithEmailAndPassword);
    on<SignedOut>(_onSignedOut);
  }
  final AuthRepository authRepository;

  Future<void> _onIsAuthenticated(
    IsAuthenticated event,
    Emitter<AuthState> emit,
  ) async {
    final currentUser = authRepository.currentUser;
    if (currentUser != null) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      emit(
        state.copyWith(
          authStatus: AuthStatus.authenticated,
          agent: Agent(
            id: currentUser.uid,
            email: currentUser.email!,
          ),
        ),
      );
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onSignedInWithEmailAndPassword(
    SignedInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(
        state.copyWith(signInWithEmailStatus: Status.loading()),
      );
      final user = await authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          signInWithEmailStatus: Status.success(),
          authStatus: AuthStatus.authenticated,
          agent: Agent(id: user.uid, email: user.email!),
        ),
      );
    } on Failure catch (f) {
      emit(state.copyWith(signInWithEmailStatus: Status.failure(f)));
    }
  }

  Future<void> _onCreatedUserWithEmailAndPassword(
    CreatedUserWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(createWithEmailStatus: Status.loading()));
      final user = await authRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          createWithEmailStatus: Status.success(),
          authStatus: AuthStatus.authenticated,
          agent: Agent(id: user.uid, email: user.email!),
        ),
      );
    } on Failure catch (f) {
      emit(state.copyWith(createWithEmailStatus: Status.failure(f)));
    }
  }

  Future<void> _onSignedOut(SignedOut event, Emitter<AuthState> emit) async {
    try {
      await authRepository.signOut();
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.authenticated));
    }
  }
}
