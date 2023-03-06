import 'package:firebase_kyc/src/core/domain/enums.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  Future<bool> isLocationPermissionGranted() async {
    return Permission.location.isGranted;
  }

  Future<LocationPermissionStatus> requestLocationPermission() async {
    final permission = await Permission.location.request();
    if (permission.isLimited || permission.isGranted) {
      return LocationPermissionStatus.granted;
    } else if (permission.isDenied) {
      return LocationPermissionStatus.denied;
    } else {
      return LocationPermissionStatus.permanentlyDenied;
    }
  }

  Future<bool> isCameraPermissionGranted() async {
    return Permission.camera.isGranted;
  }

  Future<CameraPermissionStatus> requestCameraPermission() async {
    final permission = await Permission.camera.request();
    if (permission.isLimited || permission.isGranted) {
      return CameraPermissionStatus.granted;
    } else if (permission.isDenied) {
      return CameraPermissionStatus.denied;
    } else {
      return CameraPermissionStatus.permanentlyDenied;
    }
  }

  Future<void> openSetting() async {
    await openAppSettings();
  }
}
