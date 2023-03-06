part of 'create_user_bloc.dart';

abstract class CreateUserEvent {
  const CreateUserEvent();
}

class NameChanged extends CreateUserEvent {
  NameChanged(this.name);

  final String name;
}

class EmailChanged extends CreateUserEvent {
  EmailChanged(this.email);

  final String email;
}

class PhoneChanged extends CreateUserEvent {
  PhoneChanged(this.phone);

  final String phone;
}

class ImageUploaded extends CreateUserEvent {
  ImageUploaded({
    required this.file,
  });
  File file;
}

class DataUploaded extends CreateUserEvent {
  DataUploaded(this.agentId);

  final String agentId;
}

class LocationChanged extends CreateUserEvent {
  LocationChanged(this.locationInfo);

  final LocationInfo locationInfo;
}
