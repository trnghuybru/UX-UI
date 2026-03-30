import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

// ─── In-memory cache ────────────────────────────────────────────────────────
class _WeatherCache {
  CurrentWeatherModel? current;
  List<ForecastDayModel>? forecast;
  double? lat;
  double? lon;
  DateTime? fetchedAt;

  static const _ttl = Duration(minutes: 30);

  bool get isValid {
    if (fetchedAt == null || current == null || forecast == null) return false;
    return DateTime.now().difference(fetchedAt!) < _ttl;
  }

  bool isSameLocation(double lat, double lon) {
    if (this.lat == null || this.lon == null) return false;
    return (this.lat! - lat).abs() < 0.01 && (this.lon! - lon).abs() < 0.01;
  }

  void save(CurrentWeatherModel c, List<ForecastDayModel> f, double lat, double lon) {
    current = c;
    forecast = f;
    this.lat = lat;
    this.lon = lon;
    fetchedAt = DateTime.now();
  }

  void invalidate() => fetchedAt = null;
}
// ────────────────────────────────────────────────────────────────────────────

class WeatherService {
  static const String _apiKey = '2cc9c9c4a627c87434996a5a261cd351';
  static const String _base = 'https://api.openweathermap.org/data/2.5';
  static const String _geoBase = 'https://api.openweathermap.org/geo/1.0';

  // Shared cache across all instances
  static final _WeatherCache _cache = _WeatherCache();

  /// Reverse geocoding — get proper city name from coordinates
  Future<String> fetchCityName(double lat, double lon) async {
    try {
      final url = Uri.parse('$_geoBase/reverse?lat=$lat&lon=$lon&limit=5&appid=$_apiKey');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        for (final item in data) {
          final name = item['local_names']?['vi'] ?? item['name'] ?? '';
          if (name.isNotEmpty) return name;
        }
      }
    } catch (_) {}
    return 'Vị trí của bạn';
  }

  /// GET /data/2.5/weather — with cache
  Future<CurrentWeatherModel> fetchCurrent(double lat, double lon) async {
    if (_cache.isValid && _cache.isSameLocation(lat, lon)) {
      return _cache.current!;
    }
    final cityNameFuture = fetchCityName(lat, lon);
    final url = Uri.parse(
        '$_base/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=vi');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final model = CurrentWeatherModel.fromJson(json.decode(res.body));
      final cityName = await cityNameFuture;
      return model.copyWith(cityName: cityName);
    }
    throw Exception('Lỗi thời tiết (${res.statusCode})');
  }

  /// GET /data/2.5/forecast — with cache
  Future<List<ForecastDayModel>> fetchForecast(double lat, double lon) async {
    if (_cache.isValid && _cache.isSameLocation(lat, lon)) {
      return _cache.forecast!;
    }
    final url = Uri.parse(
        '$_base/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=vi&cnt=40');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Lỗi dự báo (${res.statusCode})');

    final List list = json.decode(res.body)['list'];
    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month}-${now.day}';

    final Map<String, Map<String, dynamic>> dayMap = {};
    for (final item in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
      final key = '${dt.year}-${dt.month}-${dt.day}';
      if (key == todayKey) continue;
      if (!dayMap.containsKey(key)) {
        dayMap[key] = item;
      } else {
        final prev = DateTime.fromMillisecondsSinceEpoch(
            (dayMap[key]!['dt'] as int) * 1000);
        if ((dt.hour - 12).abs() < (prev.hour - 12).abs()) dayMap[key] = item;
      }
    }

    return dayMap.values
        .map((e) => ForecastDayModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  /// Fetch both current + forecast, save to cache, return as tuple
  Future<({CurrentWeatherModel current, List<ForecastDayModel> forecast})>
      fetchAll(double lat, double lon) async {
    // Return cache immediately if valid
    if (_cache.isValid && _cache.isSameLocation(lat, lon)) {
      return (current: _cache.current!, forecast: _cache.forecast!);
    }

    // Fetch in parallel
    final results = await Future.wait([
      fetchCurrent(lat, lon),
      fetchForecast(lat, lon),
    ]);

    final current = results[0] as CurrentWeatherModel;
    final forecast = results[1] as List<ForecastDayModel>;

    // Save to cache
    _cache.save(current, forecast, lat, lon);

    return (current: current, forecast: forecast);
  }
}
