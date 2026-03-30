import 'package:location/location.dart';

class LocationService {
  static const double _defaultLat = 16.0544; // Đà Nẵng fallback
  static const double _defaultLon = 108.2022;

  static Future<({double lat, double lon})> getCurrentLocation() async {
    final location = Location();

    // Check/request service
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return (lat: _defaultLat, lon: _defaultLon);
    }

    // Check/request permission
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return (lat: _defaultLat, lon: _defaultLon);
      }
    }

    try {
      final data = await location.getLocation();
      final lat = data.latitude ?? _defaultLat;
      final lon = data.longitude ?? _defaultLon;
      return (lat: lat, lon: lon);
    } catch (_) {
      return (lat: _defaultLat, lon: _defaultLon);
    }
  }
}
