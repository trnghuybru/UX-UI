import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';

class DirectionsService {
  static const String _apiKey = 'yoNpi4Q0a42LWpIEJZo6c2b1fd6QWcO6RzI2iMdu';
  static const String _baseUrl = 'https://rsapi.goong.io/Direction';

  static Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final String originStr = '${origin.latitude},${origin.longitude}';
    final String destStr = '${destination.latitude},${destination.longitude}';
    
    final Uri url = Uri.parse('$_baseUrl?origin=$originStr&destination=$destStr&vehicle=car&api_key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
          return _decodePolyline(encodedPolyline);
        }
      }
      return [];
    } catch (e) {
      print('Directions Error: $e');
      return [];
    }
  }

  // Google Polyline Algorithm Decoder
  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}
