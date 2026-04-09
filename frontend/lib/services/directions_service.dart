import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';

class DirectionsResult {
  final List<LatLng> points;
  final String status;
  DirectionsResult(this.points, this.status);
}

class DirectionsService {
  static const String _apiKey = 'yoNpi4Q0a42LWpIEJZo6c2b1fd6QWcO6RzI2iMdu';
  static const String _baseUrl = 'https://rsapi.goong.io/Direction';

  static Future<DirectionsResult> getRoute(LatLng origin, LatLng destination) async {
    final String originStr = '${origin.latitude},${origin.longitude}';
    final String destStr = '${destination.latitude},${destination.longitude}';
    
    final Uri url = Uri.parse('$_baseUrl?origin=$originStr&destination=$destStr&vehicle=car&api_key=$_apiKey');
    debugPrint('REQUESTING DIRECTIONS: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if ((data['status'] == 'OK' || data['code'] == 'Ok') && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final String? enc = route['overview_polyline']?['points'] ?? 
                             route['polyline']?['points'] ?? 
                             route['polyline'] ??
                             route['geometry']; // ADDED GEOMETRY FALLBACK
          
          if (enc != null) return DirectionsResult(_decodePolyline(enc), 'OK');
        }
        return DirectionsResult([], data['status'] ?? data['code'] ?? 'NO_ROUTES');
      }
      return DirectionsResult([], 'STATUS_${response.statusCode}');
    } catch (e) {
      debugPrint('Directions Error Attempt 1: $e');
    }

    // FALLBACK: Try lng,lat order
    try {
      final String originStrRev = '${origin.longitude},${origin.latitude}';
      final String destStrRev = '${destination.longitude},${destination.latitude}';
      final Uri urlRev = Uri.parse('$_baseUrl?origin=$originStrRev&destination=$destStrRev&vehicle=car&api_key=$_apiKey');
      
      debugPrint('RETRYING DIRECTIONS: $urlRev');
      final response = await http.get(urlRev);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if ((data['status'] == 'OK' || data['code'] == 'Ok') && data['routes'] != null && data['routes'].isNotEmpty) {
           final route = data['routes'][0];
           final String? enc = route['overview_polyline']?['points'] ?? 
                              route['polyline']?['points'] ?? 
                              route['polyline'] ??
                              route['geometry'];
           if (enc != null) return DirectionsResult(_decodePolyline(enc), 'OK');
        }
        return DirectionsResult([], data['status'] ?? data['code'] ?? 'NO_ROUTES');
      }
      return DirectionsResult([], 'STATUS_${response.statusCode}');
    } catch (e) {
      return DirectionsResult([], 'EXCEPTION: $e');
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
