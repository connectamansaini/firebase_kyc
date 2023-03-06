part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class UsersRequested extends UserEvent {
  UsersRequested(this.agentId);

  final String agentId;
}

class UserAdded extends UserEvent {
  UserAdded(this.user);

  final User user;
}
