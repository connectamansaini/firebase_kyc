part of 'create_user_bloc.dart';

class CreateUserState {
  CreateUserState({
    this.user = User.empty,
    this.imageUploadStatus = const StatusInitial(),
    this.uploadUserStatus = const StatusInitial(),
  });

  final User user;
  final Status imageUploadStatus;
  final Status uploadUserStatus;

  CreateUserState copyWith({
    User? user,
    Status? imageUploadStatus,
    Status? uploadUserStatus,
  }) {
    return CreateUserState(
      user: user ?? this.user,
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
      uploadUserStatus: uploadUserStatus ?? this.uploadUserStatus,
    );
  }
}
