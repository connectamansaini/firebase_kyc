part of 'permission_bloc.dart';

class PermissionState {
  PermissionState({
    this.locationPermissionStatus = LocationPermissionStatus.initial,
    this.cameraPermissionStatus = CameraPermissionStatus.initial,
  });

  final LocationPermissionStatus locationPermissionStatus;
  final CameraPermissionStatus cameraPermissionStatus;

  PermissionState copyWith({
    LocationPermissionStatus? locationPermissionStatus,
    CameraPermissionStatus? cameraPermissionStatus,
  }) {
    return PermissionState(
      locationPermissionStatus:
          locationPermissionStatus ?? this.locationPermissionStatus,
      cameraPermissionStatus:
          cameraPermissionStatus ?? this.cameraPermissionStatus,
    );
  }
}
