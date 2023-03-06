import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';
import 'package:firebase_kyc/src/location/models/location_info.dart';
import 'package:firebase_kyc/src/user/models/user.dart';
import 'package:firebase_kyc/src/user/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

part 'create_user_event.dart';
part 'create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  CreateUserBloc(this.userRepository) : super(CreateUserState()) {
    on<NameChanged>(_onNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<ImageUploaded>(_onImageUploaded);
    on<DataUploaded>(_onDataUploaded);
    on<LocationChanged>(_onLocationChanged);
  }
  final UserRepository userRepository;

  void _onNameChanged(NameChanged event, Emitter<CreateUserState> emit) {
    emit(state.copyWith(user: state.user.copyWith(name: event.name)));
  }

  void _onEmailChanged(EmailChanged event, Emitter<CreateUserState> emit) {
    emit(state.copyWith(user: state.user.copyWith(email: event.email)));
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<CreateUserState> emit) {
    emit(state.copyWith(user: state.user.copyWith(phone: event.phone)));
  }

  Future<void> _onImageUploaded(
    ImageUploaded event,
    Emitter<CreateUserState> emit,
  ) async {
    try {
      emit(state.copyWith(imageUploadStatus: Status.loading()));
      final url = await userRepository.uploadImage(event.file);
      emit(
        state.copyWith(
          user: state.user.copyWith(url: url),
          imageUploadStatus: Status.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(imageUploadStatus: Status.failure()));
    }
  }

  Future<void> _onDataUploaded(
    DataUploaded event,
    Emitter<CreateUserState> emit,
  ) async {
    try {
      emit(state.copyWith(uploadUserStatus: Status.loading()));
      final date = DateTime.now();
      final id = const Uuid().v4();
      final user =
          state.user.copyWith(time: date.millisecondsSinceEpoch, id: id);

      emit(state.copyWith(user: user));

      await userRepository.addData(
        user,
        event.agentId,
      );
      emit(
        state.copyWith(
          uploadUserStatus: Status.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(uploadUserStatus: Status.failure()));
    }
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<CreateUserState> emit,
  ) {
    emit(
      state.copyWith(
        user: state.user.copyWith(
          lat: event.locationInfo.latitude,
          lon: event.locationInfo.longitude,
        ),
      ),
    );
  }
}
