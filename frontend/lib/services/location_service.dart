import 'dart:async';
import 'dart:math';
import 'package:location/location.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class LocationService {
  static const double _defaultLat = 15.978765;
  static const double _defaultLon = 108.236751;

  static Future<bool> requestPermissions() async {
    final location = Location();
    
    // Check/request service
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }

    // Check/request permission
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }
    
    return permission == PermissionStatus.granted;
  }

  static Future<({double lat, double lon})> getCurrentLocation() async {
    final location = Location();

    if (!(await requestPermissions())) {
      return (lat: _defaultLat, lon: _defaultLon);
    }

    // Set high accuracy
    location.changeSettings(accuracy: LocationAccuracy.high);

    try {
      // Add a 3-second timeout for emulators/slow GPS
      final data = await location.getLocation().timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw TimeoutException('Location timed out'),
      );
      final lat = data.latitude ?? _defaultLat;
      final lon = data.longitude ?? _defaultLon;
      return (lat: lat, lon: lon);
    } catch (_) {
      return (lat: _defaultLat, lon: _defaultLon);
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
