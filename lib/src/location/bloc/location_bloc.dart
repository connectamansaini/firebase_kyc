import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';
import 'package:firebase_kyc/src/location/models/location_info.dart';
import 'package:firebase_kyc/src/location/repository/location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(this.locationRepository) : super(LocationState()) {
    on<LocationInfoRequested>(_onLocationInfoRequested);
  }
  final LocationRepository locationRepository;

  Future<void> _onLocationInfoRequested(
    LocationInfoRequested event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(state.copyWith(locationInfoStatus: Status.loading()));
      final locationInfo = await locationRepository.getLocationInfo();
      emit(
        state.copyWith(
          locationInfoStatus: Status.success(),
          locationInfo: locationInfo,
        ),
      );
    } catch (e) {
      emit(state.copyWith(locationInfoStatus: Status.failure()));
    }
  }
}
