import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';
import 'package:firebase_kyc/src/image_picker/repository/image_picker_repository.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc(this.imagePickerRepository)
      : super(const ImagePickerState()) {
    on<CameraPhotoPicked>(_onCameraPhotoPicked);
  }

  final ImagePickerRepository imagePickerRepository;

  Future<void> _onCameraPhotoPicked(
    CameraPhotoPicked event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(state.copyWith(cameraPhotoStatus: Status.loading()));

    final file = await imagePickerRepository.getCameraPhoto();
    emit(
      state.copyWith(
        pickedImage: file,
        cameraPhotoStatus: Status.success(),
      ),
    );
  }
}
