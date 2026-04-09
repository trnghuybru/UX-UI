import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class LocationService {

  static Future<bool> requestPermissions() async {
    final location = loc.Location();
    
    // 1. Check and request location SERVICE (GPS toggle)
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          debugPrint('Location service NOT ENABLED');
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error checking location service: $e');
    }

    if (kIsWeb) return true;

    // 2. Request permission using permission_handler (more stable on Android/iOS)
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    
    if (status.isPermanentlyDenied) {
      debugPrint('Location permission PERMANENTLY DENIED. User must open settings.');
      // Optionally show a dialog to open settings
      return false;
    }

    return status.isGranted || status.isLimited;
  }

  static Future<({double lat, double lon})?> getCurrentLocation() async {
    final location = loc.Location();

    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      debugPrint('LOCATION PERMISSION REFUSED');
      return null;
    }

    // Set high accuracy
    location.changeSettings(accuracy: loc.LocationAccuracy.high);

    try {
      debugPrint('REQUESTING CURRENT LOCATION...');
      // Use shorter timeout but fallback to one-time data request
      final data = await location.getLocation().timeout(
        const Duration(seconds: 15),
      );
      
      final lat = data.latitude;
      final lon = data.longitude;
      
      if (lat == null || lon == null) {
        debugPrint('Location data is NULL');
        return null;
      }
      
      debugPrint('LOCATION DETECTED: [$lat, $lon]');
      return (lat: lat, lon: lon);
    } catch (e) {
      debugPrint('Location Error: $e');
      
      if (kIsWeb) {
        debugPrint('FALLBACK MOCK LOCATION (Đà Nẵng) - Web GPS issue');
        return (lat: 16.047079, lon: 108.206230);
      }
      
      // On real devices, often the first request fails if GPS hasn't locked.
      // We could try one more time or just return null
      return null;
    }
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // pi / 180
    final double a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  static List<List<LatLng>> generateCirclePoints(double centerLat, double centerLon, double radiusKm, {int points = 64}) {
    const double p = 0.017453292519943295; // pi / 180
    final double radiusInRadians = radiusKm / 6371.0;
    final double centerLatRadians = centerLat * p;
    final double centerLonRadians = centerLon * p;
    
    List<LatLng> circleCoords = [];

    for (int i = 0; i <= points; i++) {
        final double bearing = 2 * pi * i / points;
        final double latRadians = asin(sin(centerLatRadians) * cos(radiusInRadians) +
            cos(centerLatRadians) * sin(radiusInRadians) * cos(bearing));
        final double lonRadians = centerLonRadians +
            atan2(sin(bearing) * sin(radiusInRadians) * cos(centerLatRadians),
                cos(radiusInRadians) - sin(centerLatRadians) * sin(latRadians));
        
        circleCoords.add(LatLng(latRadians / p, lonRadians / p));
    }
    
    return [circleCoords]; // Return as a nested list for Fill layers
  }
}
