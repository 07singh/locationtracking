import 'package:intl/intl.dart';

class LocationDataModel {
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final String pincode;
  final DateTime timestamp;

  LocationDataModel({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.pincode,
    required this.timestamp,
  });

  String get formattedTimestamp =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

  @override
  String toString() {
    return 'Latitude: \$latitude, Longitude: \$longitude, City: \$city, State: \$state, Pincode: \$pincode, Timestamp: \$formattedTimestamp';
  }
}

