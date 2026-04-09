import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _service = WeatherService();

  late Future<_Bundle> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_Bundle> _load() async {
    final pos = await LocationService.getCurrentLocation();
    if (pos == null) throw Exception('Không thể lấy vị trí hiện tại. Vui lòng bật GPS.');
    final data = await _service.fetchAll(pos.lat, pos.lon);
    return _Bundle(current: data.current, forecast: data.forecast);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Dự báo thời tiết',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF0288D1), Color(0xFF00ACC1)],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<_Bundle>(
            future: _future,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (snap.hasError) return _errorWidget(snap.error.toString());
              if (!snap.hasData) return _errorWidget('Không có dữ liệu');
              return _buildContent(snap.data!);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(_Bundle data) {
    final c = data.current;
    final now = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // City & Country
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              Text('${c.cityName}, ${c.country}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, d MMMM', 'vi').format(now),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Icon + Temp
          _icon(c.icon, size: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${c.temp.round()}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 90, fontWeight: FontWeight.bold, height: 1)),
              const Text('°C',
                  style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w300)),
            ],
          ),
          Text(c.description,
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text('Cao ${c.tempMax.round()}°  •  Thấp ${c.tempMin.round()}°',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
          const SizedBox(height: 4),
          Text('Cảm giác ${c.feelsLike.round()}°C',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),

          const SizedBox(height: 24),

          // Detail grid
          _detailGrid(c),
          const SizedBox(height: 24),

          // Sunrise / Sunset
          _sunriseSunsetRow(c),
          const SizedBox(height: 32),

          // Forecast
          _forecastSection(data.forecast),
        ],
      ),
    );
  }

  Widget _detailGrid(CurrentWeatherModel c) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.6,
        children: [
          _statItem(Icons.water_drop_outlined, '${c.humidity}%', 'Độ ẩm'),
          _statItem(Icons.air, '${c.windSpeed.toStringAsFixed(1)} m/s', 'Gió'),
          _statItem(Icons.cloud_outlined, '${c.clouds}%', 'Mây'),
          _statItem(Icons.compress, '${c.pressure} hPa', 'Áp suất'),
          _statItem(Icons.visibility_outlined,
              '${(c.visibility / 1000).toStringAsFixed(1)} km', 'Tầm nhìn'),
          if (c.rain1h != null)
            _statItem(Icons.umbrella_outlined, '${c.rain1h!.toStringAsFixed(1)} mm', 'Mưa/giờ')
          else
            _statItem(Icons.thermostat_outlined, '${c.feelsLike.round()}°C', 'Cảm giác'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 10)),
      ],
    );
  }

  Widget _sunriseSunsetRow(CurrentWeatherModel c) {
    final sunrise = DateTime.fromMillisecondsSinceEpoch(c.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(c.sunset * 1000);
    return Row(
      children: [
        Expanded(
          child: _sunCard(
            Icons.wb_twilight,
            'Bình minh',
            DateFormat('HH:mm').format(sunrise),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _sunCard(
            Icons.nights_stay_outlined,
            'Hoàng hôn',
            DateFormat('HH:mm').format(sunset),
          ),
        ),
      ],
    );
  }

  Widget _sunCard(IconData icon, String label, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(time,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _forecastSection(List<ForecastDayModel> forecast) {
    if (forecast.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dự báo vài ngày tới',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: forecast.take(5).toList().asMap().entries.map((entry) {
              final i = entry.key;
              final day = entry.value;
              final count = forecast.length > 5 ? 5 : forecast.length;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            DateFormat('EEEE', 'vi').format(day.dateTime),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        _icon(day.icon, size: 30),
                        const SizedBox(width: 10),
                        Text('${day.tempMin.round()}°',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.55), fontSize: 14)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text('/', style: TextStyle(color: Colors.white38)),
                        ),
                        Text('${day.tempMax.round()}°',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  if (i < count - 1)
                    Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.12),
                        indent: 20,
                        endIndent: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _icon(String code, {double size = 40}) {
    return Image.network(
      'https://openweathermap.org/img/wn/$code${size >= 60 ? '@2x' : ''}.png',
      width: size, height: size, fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.wb_sunny_rounded, color: Colors.white, size: size * 0.7),
      loadingBuilder: (_, child, p) =>
          p == null ? child : SizedBox(width: size, height: size),
    );
  }

  Widget _errorWidget(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 56),
            const SizedBox(height: 16),
            const Text('Không thể tải dữ liệu',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                maxLines: 4,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _future = _load();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bundle {
  final CurrentWeatherModel current;
  final List<ForecastDayModel> forecast;
  _Bundle({required this.current, required this.forecast});
}
