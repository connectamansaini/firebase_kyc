import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_kyc/src/core/domain/enums.dart';
import 'package:firebase_kyc/src/permission/repository/permission_repository.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc(this.permissionRepository) : super(PermissionState()) {
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
    on<CameraPermissionRequested>(_onCameraPermissionRequested);
  }
  final PermissionRepository permissionRepository;

  Future<void> _onLocationPermissionRequested(
    LocationPermissionRequested event,
    Emitter<PermissionState> emit,
  ) async {
    final isGranted = await permissionRepository.isLocationPermissionGranted();

    if (isGranted) {
      emit(
        state.copyWith(
          locationPermissionStatus: LocationPermissionStatus.granted,
        ),
      );
    } else {
      final currentStatus =
          await permissionRepository.requestLocationPermission();
      emit(state.copyWith(locationPermissionStatus: currentStatus));
    }
  }

  Future<void> _onCameraPermissionRequested(
    CameraPermissionRequested event,
    Emitter<PermissionState> emit,
  ) async {
    final isGranted = await permissionRepository.isCameraPermissionGranted();

    if (isGranted) {
      emit(
        state.copyWith(
          cameraPermissionStatus: CameraPermissionStatus.granted,
        ),
      );
    } else {
      final currentStatus =
          await permissionRepository.requestCameraPermission();
      emit(state.copyWith(cameraPermissionStatus: currentStatus));
    }
  }
}
