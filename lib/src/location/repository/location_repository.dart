import 'package:firebase_kyc/src/location/models/location_info.dart';
import 'package:location/location.dart';

class LocationRepository {
  Location location = Location();

  Future<LocationInfo> getLocationInfo() async {
    // await location.changeSettings(accuracy: LocationAccuracy.high);
    final locationData = await location.getLocation();
    return LocationInfo(
      latitude: locationData.latitude ?? 0,
      longitude: locationData.longitude ?? 0,
    );
  }
}
