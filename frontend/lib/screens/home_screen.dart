import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAlertExpanded = true;
  CurrentWeatherModel? _weather;
  bool _weatherLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      final data = await WeatherService().fetchAll(pos.lat, pos.lon);
      if (mounted) setState(() { _weather = data.current; _weatherLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _weatherLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E11) : Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        onNotificationPressed: () {
          setState(() {
            _isAlertExpanded = !_isAlertExpanded;
          });
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyAlertCard(isDark),
            const SizedBox(height: 24),
            _buildWeatherCard(isDark),
            const SizedBox(height: 24),
            _buildHourlyForecastSection(isDark),
            const SizedBox(height: 24),
            _build5DayForecastCard(isDark),
            const SizedBox(height: 24),
            _buildAirQualityCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyAlertCard(bool isDark) {
    final alertColor = isDark ? const Color(0xFF930022) : Theme.of(context).colorScheme.error;
    final alertShadow = isDark ? const Color(0x7F000000) : const Color(0x33B90538);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: alertColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? const [
                BoxShadow(color: Color(0x7F000000), blurRadius: 50, offset: Offset(0, 25), spreadRadius: -12),
              ]
            : [
                BoxShadow(color: alertShadow, blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
              ],
      ),
      child: Stack(
        children: [
          if (isDark)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 358,
                height: 201.50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33FFB2B7), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
                    BoxShadow(color: Color(0x33FFB2B7), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'CẢNH BÁO BÃO KHẨN CẤP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDark ? 20 : 18,
                          fontFamily: isDark ? 'Montserrat' : null,
                          fontWeight: FontWeight.w800,
                          height: 1.40,
                          letterSpacing: -0.50,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAlertExpanded = !_isAlertExpanded;
                        });
                      },
                      child: Icon(
                        _isAlertExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _isAlertExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Bão số 5 đang đổ bộ trực tiếp vào khu vực của bạn. Hãy di chuyển đến nơi an toàn ngay lập tức.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.90),
                                fontSize: 14,
                                fontFamily: isDark ? 'Manrope' : null,
                                fontWeight: FontWeight.w400,
                                height: 1.63,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on, color: isDark ? const Color(0xFFFFB2B7) : alertColor, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Xem điểm trú ẩn gần nhất',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFFFFB2B7) : alertColor,
                                      fontSize: 16,
                                      fontFamily: isDark ? 'Manrope' : null,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(bool isDark) {
    const primaryDimColor = Color(0xFF004395);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeatherScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.06, 0.05),
          end: const Alignment(1.06, 0.95),
          colors: isDark ? const [Color(0xFF002D6B), Color(0xFF004395)] : [Theme.of(context).colorScheme.primary, primaryDimColor],
        ),
        borderRadius: BorderRadius.circular(40),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
        boxShadow: isDark
            ? const [BoxShadow(color: Color(0x4C000000), blurRadius: 40, offset: Offset(0, 20))]
            : [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    _weatherLoading
                        ? '...'                         
                        : _weather != null
                            ? _weather!.cityName    
                            : 'Đà Nẵng',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFD8E2FF) : Colors.white,
                      fontSize: 18,
                      fontFamily: isDark ? 'Montserrat' : null,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _weatherLoading
                        ? '--'
                        : '${_weather?.temp.round() ?? '--'}',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFD8E2FF) : Colors.white,
                      fontSize: 96,
                      fontFamily: isDark ? 'Manrope' : null,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -4.80,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '°C',
                      style: TextStyle(
                        color: (isDark ? const Color(0xFFD8E2FF) : Colors.white).withValues(alpha: 0.80),
                        fontSize: 36,
                        fontFamily: isDark ? 'Manrope' : null,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _weatherLoading ? 'Đang tải...' : (_weather?.description ?? ''),
                style: TextStyle(
                  color: isDark ? const Color(0xFFD8E2FF) : Colors.white,
                  fontSize: 20,
                  fontFamily: isDark ? 'Manrope' : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _weatherLoading
                    ? ''
                    : _weather != null
                        ? 'Cảm giác như ${_weather!.feelsLike.round()}°C'
                        : '',
                style: TextStyle(
                  color: (isDark ? const Color(0xFFD8E2FF) : Colors.white).withValues(alpha: 0.80),
                  fontSize: 14,
                  fontFamily: isDark ? 'Manrope' : null,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildWeatherDetailItem(Icons.water_drop_outlined, 'ĐỘ ẨM', _weather != null ? '${_weather!.humidity}%' : '--', itemWidth, isDark),
                      _buildWeatherDetailItem(Icons.air_outlined, 'GIÓ', _weather != null ? '${_weather!.windSpeed.toStringAsFixed(1)} m/s' : '--', itemWidth, isDark),
                      _buildWeatherDetailItem(Icons.visibility_outlined, 'TẦM NHÌN', _weather != null ? '${(_weather!.visibility / 1000).toStringAsFixed(1)} km' : '--', itemWidth, isDark),
                      _buildWeatherDetailItem(Icons.speed_outlined, 'ÁP SUẤT', _weather != null ? '${_weather!.pressure} hPa' : '--', itemWidth, isDark),
                    ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailItem(IconData icon, String title, String value, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.10),
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.10)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: isDark ? const Color(0xFFD8E2FF) : Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: (isDark ? const Color(0xFFD8E2FF) : Colors.white).withValues(alpha: 0.70),
                    fontSize: 10,
                    fontFamily: isDark ? 'Manrope' : null,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFD8E2FF) : Colors.white,
                    fontSize: 16,
                    fontFamily: isDark ? 'Manrope' : null,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecastSection(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dự báo theo giờ',
              style: TextStyle(
                color: isDark ? const Color(0xFFE0E3E5) : Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontFamily: isDark ? 'Manrope' : null,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeatherScreen()),
                );
              },
              child: Text(
                'Xem tất cả',
                style: TextStyle(
                  color: isDark ? const Color(0xFFADC6FF) : Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontFamily: isDark ? 'Montserrat' : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildHourlyItem('Bây giờ', '28°', Icons.wb_sunny, false, isDark),
              const SizedBox(width: 12),
              _buildHourlyItem('12:00', '30°', Icons.wb_sunny, true, isDark),
              const SizedBox(width: 12),
              _buildHourlyItem('15:00', '29°', Icons.cloud, false, isDark),
              const SizedBox(width: 12),
              _buildHourlyItem('18:00', '26°', Icons.cloud_queue, false, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyItem(String time, String temp, IconData icon, bool isActive, bool isDark) {
    final activeBg = isDark ? const Color(0xFFADC6FF) : Theme.of(context).colorScheme.primary;
    final inactiveBg = isDark ? const Color(0xFF282B2F) : Theme.of(context).cardColor;

    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? activeBg : inactiveBg,
        borderRadius: BorderRadius.circular(24),
        border: isActive 
            ? null 
            : Border.all(color: isDark ? const Color(0x1942474E) : Theme.of(context).dividerColor),
        boxShadow: isActive
            ? (isDark 
                ? [
                    const BoxShadow(color: Color(0x19ADC6FF), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
                    const BoxShadow(color: Color(0x19ADC6FF), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
                  ]
                : [
                    BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3)
                  ])
            : [
                if (!isDark) const BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))
              ],
      ),
      child: Column(
        children: [
          Text(
            time,
            style: TextStyle(
              color: isActive 
                  ? (isDark ? const Color(0xFF002D6B) : Colors.white) 
                  : (isDark ? const Color(0xFFC2C6D6) : Theme.of(context).colorScheme.onSurfaceVariant),
              fontSize: 12,
              fontFamily: isDark ? 'Manrope' : null,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Icon(
            icon, 
            color: isActive 
                ? (isDark ? const Color(0xFF002D6B) : Colors.white) 
                : (isDark ? const Color(0xFFE0E3E5) : Theme.of(context).colorScheme.onSurface), 
            size: 28
          ),
          const SizedBox(height: 12),
          Text(
            temp,
            style: TextStyle(
              color: isActive 
                  ? (isDark ? const Color(0xFF002D6B) : Colors.white) 
                  : (isDark ? const Color(0xFFE0E3E5) : Theme.of(context).colorScheme.onSurface),
              fontSize: 18,
              fontFamily: isDark ? 'Manrope' : null,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build5DayForecastCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191C1E) : AppTheme.lightSurfaceBright,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dự báo 5 ngày tới',
            style: TextStyle(
              color: isDark ? const Color(0xFFE0E3E5) : Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontFamily: isDark ? 'Manrope' : null,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildDailyForecastItem('Thứ 2', 'Nắng', Icons.wb_sunny, '22°', '29°', 0.4, 0.8, isDark: isDark),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 3', 'Mây', Icons.cloud, '23°', '30°', 0.5, 0.9, isDark: isDark, isHighlighted: true),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 4', 'Nhiều mây', Icons.cloud_queue, '24°', '28°', 0.3, 0.7, isDark: isDark),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 5', 'Mưa rào', Icons.umbrella, '21°', '25°', 0.1, 0.5, isDark: isDark, isHighlighted: true),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 6', 'Nắng ráo', Icons.wb_sunny, '22°', '27°', 0.4, 0.8, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildDailyForecastItem(
      String day, String condition, IconData icon, String minTemp, String maxTemp, double barStart, double barEnd,
      {bool isDark = false, bool isHighlighted = false}) {
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted 
            ? (isDark ? const Color(0xFF282B2F) : Colors.white.withValues(alpha: 0.50)) 
            : (isDark ? const Color(0xFF191C1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              day,
              style: TextStyle(
                color: isDark ? const Color(0xFFC2C6D6) : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontFamily: isDark ? 'Manrope' : null,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(icon, color: isDark ? const Color(0xFFC2C6D6) : Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                     condition,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFC2C6D6) : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontFamily: isDark ? 'Manrope' : null,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    minTemp,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF8C9199) : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontFamily: isDark ? 'Manrope' : null,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF42474E) : Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Positioned(
                              left: constraints.maxWidth * barStart,
                              width: constraints.maxWidth * (barEnd - barStart),
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFFADC6FF) : Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: Text(
                    maxTemp,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFE0E3E5) : Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontFamily: isDark ? 'Manrope' : null,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191C1E) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: const Color(0x33475569)) : Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF16A34A).withValues(alpha: 0.2) : const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Color(0xFF16A34A), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chất lượng không khí',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFE0E3E5) : Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '42 • Tốt (Vùng an toàn)',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFC2C6D6) : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: isDark ? const Color(0xFFC2C6D6) : Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
