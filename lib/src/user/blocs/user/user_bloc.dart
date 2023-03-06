import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';
import 'package:firebase_kyc/src/user/models/user.dart';
import 'package:firebase_kyc/src/user/repository/user_repository.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this.userRepository) : super(UserState()) {
    on<UsersRequested>(_onUsersRequested);
    on<UserAdded>(_onUserAdded);
  }

  final UserRepository userRepository;

  Future<void> _onUsersRequested(
    UsersRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(usersStatus: Status.loading()));
      final usersList = await userRepository.getUsers(event.agentId);
      emit(
        state.copyWith(
          users: usersList,
          usersStatus: Status.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(usersStatus: Status.failure()));
    }
  }

  void _onUserAdded(UserAdded event, Emitter<UserState> emit) {
    emit(state.copyWith(users: List.of(state.users)..add(event.user)));
  }
}
