import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  final String _apiKey = "AIzaSyB3b4ICjoQKANYLoN9CMpvFtfmJrSQq2HQ"; // Replace with your actual API key

  Future<Map<String, String>> getAddressFromLatLng(
      double lat, double lng) async {
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='
        '$lat,$lng&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final addressComponents = data['results'][0]['address_components'];
        String city = '';
        String state = '';
        String pincode = '';

        for (var component in addressComponents) {
          final types = component['types'] as List;
          if (types.contains('locality')) {
            city = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          }

           else if (types.contains('postal_code')) {
            pincode = component['long_name'];
          }
        }
        return {'city': city, 'state': state, 'pincode': pincode};
      }
    }
    return {'city': 'Unknown', 'state': 'Unknown', 'pincode': 'Unknown'};
  }
}

