part of 'user_bloc.dart';

class UserState {
  UserState({
    this.usersStatus = const StatusInitial(),
    this.users = const [],
  });

  final Status usersStatus;
  final List<User> users;

  UserState copyWith({
    Status? usersStatus,
    List<User>? users,
  }) {
    return UserState(
      usersStatus: usersStatus ?? this.usersStatus,
      users: users ?? this.users,
    );
  }
}
