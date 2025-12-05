import 'package:geolocator/geolocator.dart';
import 'package:flutter_location_app/models/location_model.dart';

class LocationMapper {
  static LocationDataModel fromPositionAndAddress(
      Position position, Map<String, String> address) {
    return LocationDataModel(
      latitude: position.latitude,
      longitude: position.longitude,
      city: address['city'] ?? 'Unknown',
      state: address['state'] ?? 'Unknown',
      pincode: address['pincode'] ?? 'Unknown',
      timestamp: position.timestamp ?? DateTime.now(),
    );
  }
}

