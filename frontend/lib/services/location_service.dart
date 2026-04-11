import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class LocationService {
  static final loc.Location _location = loc.Location();
  static ({double lat, double lon})? _cachedLocation;
  static DateTime? _lastFetchTime;

  static Future<bool> requestPermissions() async {
    // 1. Check and request location SERVICE (GPS toggle)
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          debugPrint('Location service NOT ENABLED');
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error checking location service: $e');
    }

    if (kIsWeb) return true;

    // 2. Request permission using permission_handler
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    
    if (status.isPermanentlyDenied) {
      debugPrint('Location permission PERMANENTLY DENIED.');
      return false;
    }

    return status.isGranted || status.isLimited;
  }

  static Future<({double lat, double lon})?> getCurrentLocation() async {
    // Check cache first (valid for 60 seconds)
    if (_cachedLocation != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!).inSeconds < 60) {
        return _cachedLocation;
      }
    }

    bool hasPermission = await requestPermissions();
    if (!hasPermission) return null;

    _location.changeSettings(
      accuracy: loc.LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 10,
    );

    try {
      debugPrint('🚀 ATTEMPTING TO GET LOCATION...');
      
      // Try a race between actual getLocation and the stream's first event
      // Sometimes one works while the other hangs on Android
      final data = await Future.any([
        _location.getLocation(),
        _location.onLocationChanged.first,
      ]).timeout(const Duration(seconds: 8));
      
      if (data.latitude != null && data.longitude != null) {
        _cachedLocation = (lat: data.latitude!, lon: data.longitude!);
        _lastFetchTime = DateTime.now();
        return _cachedLocation;
      }
    } catch (e) {
      debugPrint('⚠️ Location fetch failed: $e. Using cache if available.');
    }
    
    return _cachedLocation;
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
