import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  // Replace with your Goong API Key if different from Map Key
  static const String _apiKey = 'JTrWfKeh2gAU10vkDgc2k6NkgJGnvB1GKTVTqK0d';
  static const String _baseUrl = 'https://rsapi.goong.io/geocode';

  static Future<Map<String, double>?> getCoordinates(String address) async {
    if (address.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?address=${Uri.encodeComponent(address)}&api_key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return {
            'lat': (location['lat'] as num).toDouble(),
            'lng': (location['lng'] as num).toDouble(),
          };
        } else {
          print('Geocoding Status failed: ${data['status']} - ${data['error_message'] ?? 'No error message'}');
        }
      } else {
        print('Geocoding Server Error: ${response.statusCode} - ${response.body}');
      }
      return null;
    } catch (e) {
      print('Geocoding Error: $e');
      return null;
    }
  }

  static Future<String?> reverseGeocode(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?latlng=$lat,$lng&api_key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }
      return null;
    } catch (e) {
      print('Reverse Geocoding Error: $e');
      return null;
    }
  }
}
