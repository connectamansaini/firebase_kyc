part of 'image_picker_bloc.dart';

abstract class ImagePickerEvent {
  const ImagePickerEvent();
}
class CameraPhotoPicked extends ImagePickerEvent {}
