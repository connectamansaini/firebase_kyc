part of 'location_bloc.dart';

class LocationState {
  LocationState({
    this.locationInfoStatus = const StatusInitial(),
    this.locationInfo = const LocationInfo(),
  });

  final Status locationInfoStatus;
  final LocationInfo locationInfo;

  LocationState copyWith({
    Status? locationInfoStatus,
    LocationInfo? locationInfo,
  }) {
    return LocationState(
      locationInfoStatus: locationInfoStatus ?? this.locationInfoStatus,
      locationInfo: locationInfo ?? this.locationInfo,
    );
  }
}
