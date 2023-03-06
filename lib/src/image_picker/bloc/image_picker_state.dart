part of 'image_picker_bloc.dart';

class ImagePickerState {
  const ImagePickerState({
    this.cameraPhotoStatus = const StatusInitial(),
    this.pickedImage,
  });
  final Status cameraPhotoStatus;
  final File? pickedImage;

  ImagePickerState copyWith({
    Status? cameraPhotoStatus,
    File? pickedImage,
  }) {
    return ImagePickerState(
      cameraPhotoStatus: cameraPhotoStatus ?? this.cameraPhotoStatus,
      pickedImage: pickedImage ?? this.pickedImage,
    );
  }
}
