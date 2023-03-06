import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerRepository {
  Future<File?> getCameraPhoto() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  }
}
