part of 'location_bloc.dart';

abstract class LocationEvent {
  const LocationEvent();
}

class LocationInfoRequested extends LocationEvent {}
