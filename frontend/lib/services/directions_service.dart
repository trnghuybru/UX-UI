import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';

class RouteStep {
  final String instruction;
  final String distance;
  final String maneuver;

  RouteStep({required this.instruction, required this.distance, required this.maneuver});
}

class DirectionsResult {
  final List<LatLng> points;
  final String status;
  final List<RouteStep> steps;

  DirectionsResult(this.points, this.status, {this.steps = const []});
}

class DirectionsService {
  static const String _apiKey = 'JTrWfKeh2gAU10vkDgc2k6NkgJGnvB1GKTVTqK0d';
  static const String _baseUrl = 'https://rsapi.goong.io/Direction';

  static Future<DirectionsResult> getRoute(LatLng origin, LatLng destination) async {
    final String originStr = '${origin.latitude},${origin.longitude}';
    final String destStr = '${destination.latitude},${destination.longitude}';
    
    final Uri url = Uri.parse('$_baseUrl?origin=$originStr&destination=$destStr&vehicle=car&api_key=$_apiKey&alternatives=true');
    debugPrint('REQUESTING DIRECTIONS: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Flexible check: if status is OK OR if we simply have routes
        final bool isOk = data['status'] == 'OK' || data['code'] == 'Ok' || (data['routes'] != null && data['routes'] is List && data['routes'].isNotEmpty);
        
        if (isOk && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          
          // Parse steps
          List<RouteStep> steps = [];
          if (route['legs'] != null && route['legs'].isNotEmpty) {
            final leg = route['legs'][0];
            if (leg['steps'] != null) {
              for (var s in leg['steps']) {
                steps.add(RouteStep(
                  instruction: s['html_instructions'] ?? '',
                  distance: s['distance']?['text'] ?? '',
                  maneuver: s['maneuver'] ?? '',
                ));
              }
            }
          }

          final String? enc = route['overview_polyline']?['points'] ?? 
                             route['polyline']?['points'] ?? 
                             route['polyline'] ??
                             route['geometry'];
          
          if (enc != null) {
            final decoded = _decodePolyline(enc);
            if (decoded.isNotEmpty) return DirectionsResult(decoded, 'OK', steps: steps);
          }
        }
      }
    } catch (e) {
      debugPrint('Directions Error (Car): $e');
    }

    // FALLBACK: Try 'bike'
    try {
      final Uri urlBike = Uri.parse('$_baseUrl?origin=$originStr&destination=$destStr&vehicle=bike&api_key=$_apiKey');
      debugPrint('RETRYING DIRECTIONS (BIKE): $urlBike');
      final response = await http.get(urlBike);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final bool isOk = data['status'] == 'OK' || data['code'] == 'Ok' || (data['routes'] != null && data['routes'] is List && data['routes'].isNotEmpty);
        
        if (isOk && data['routes'] != null && data['routes'].isNotEmpty) {
           final route = data['routes'][0];

           List<RouteStep> steps = [];
           if (route['legs'] != null && route['legs'].isNotEmpty) {
             final leg = route['legs'][0];
             if (leg['steps'] != null) {
               for (var s in leg['steps']) {
                 steps.add(RouteStep(
                   instruction: s['html_instructions'] ?? '',
                   distance: s['distance']?['text'] ?? '',
                   maneuver: s['maneuver'] ?? '',
                 ));
               }
             }
           }

           final String? enc = route['overview_polyline']?['points'] ?? 
                               route['polyline']?['points'] ?? 
                               route['polyline'] ??
                               route['geometry'];
           if (enc != null) {
             final decoded = _decodePolyline(enc);
             if (decoded.isNotEmpty) return DirectionsResult(decoded, 'OK', steps: steps);
           }
        }
        return DirectionsResult([], data['status'] ?? data['code'] ?? 'NO_ROUTES', steps: []);
      }
      return DirectionsResult([], 'STATUS_${response.statusCode}', steps: []);
    } catch (e) {
      return DirectionsResult([], 'EXCEPTION: $e', steps: []);
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
