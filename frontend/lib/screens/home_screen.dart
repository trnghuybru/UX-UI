import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAlertExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        onNotificationPressed: () {
          setState(() {
            _isAlertExpanded = !_isAlertExpanded;
          });
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyAlertCard(),
            const SizedBox(height: 24),
            _buildWeatherCard(),
            const SizedBox(height: 24),
            _buildHourlyForecastSection(),
            const SizedBox(height: 24),
            _build5DayForecastCard(),
            const SizedBox(height: 24),
            _buildAirQualityCard(),
          ],
        ),
      ),
    );
  }



  Widget _buildEmergencyAlertCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFDC2C4F),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33B90538),
            blurRadius: 15,
            offset: Offset(0, 10),
            spreadRadius: -3,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'CẢNH BÁO BÃO KHẨN CẤP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: Color(0xFFB90538), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Xem điểm trú ẩn gần nhất',
                              style: TextStyle(
                                color: Color(0xFFB90538),
                                fontSize: 16,
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
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.05, 0.04),
          end: Alignment(1.05, 0.96),
          colors: [Color(0xFF0058BE), Color(0xFF2170E4)],
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330058BE),
            blurRadius: 40,
            offset: Offset(0, 20),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Hà Nội',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
              const Text(
                '28',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 96,
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
                    color: Colors.white.withValues(alpha: 0.80),
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Có mây, trời nắng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cảm giác như 30°C',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.80),
              fontSize: 14,
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
                  _buildWeatherDetailItem(Icons.water_drop_outlined, 'ĐỘ ẨM', '65%', itemWidth),
                  _buildWeatherDetailItem(Icons.air_outlined, 'GIÓ', '12km/h', itemWidth),
                  _buildWeatherDetailItem(Icons.visibility_outlined, 'TẦM NHÌN', '10km', itemWidth),
                  _buildWeatherDetailItem(Icons.speed_outlined, 'ÁP SUẤT', '1013 hPa', itemWidth),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailItem(IconData icon, String title, String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  Widget _buildHourlyForecastSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dự báo theo giờ',
              style: TextStyle(
                color: Color(0xFF191C1E),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Xem tất cả',
              style: TextStyle(
                color: const Color(0xFF0058BE),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildHourlyItem('Bây giờ', '28°', Icons.wb_sunny, false),
              const SizedBox(width: 12),
              _buildHourlyItem('12:00', '30°', Icons.wb_sunny, true),
              const SizedBox(width: 12),
              _buildHourlyItem('15:00', '29°', Icons.cloud, false),
              const SizedBox(width: 12),
              _buildHourlyItem('18:00', '26°', Icons.cloud_queue, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyItem(String time, String temp, IconData icon, bool isActive) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0058BE) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isActive ? null : Border.all(color: const Color(0x19C2C6D6)),
        boxShadow: isActive
            ? [
                const BoxShadow(
                  color: Color(0x330058BE),
                  blurRadius: 15,
                  offset: Offset(0, 10),
                  spreadRadius: -3,
                )
              ]
            : [
                const BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                )
              ],
      ),
      child: Column(
        children: [
          Text(
            time,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF424754),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Icon(icon, color: isActive ? Colors.white : const Color(0xFF191C1E), size: 28),
          const SizedBox(height: 12),
          Text(
            temp,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF191C1E),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build5DayForecastCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dự báo 5 ngày tới',
            style: TextStyle(
              color: Color(0xFF191C1E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildDailyForecastItem('Thứ 2', 'Nắng', Icons.wb_sunny, '22°', '29°', 0.4, 0.8),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 3', 'Mây', Icons.cloud, '23°', '30°', 0.5, 0.9, isHighlighted: true),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 4', 'Nhiều mây', Icons.cloud_queue, '24°', '28°', 0.3, 0.7),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 5', 'Mưa rào', Icons.umbrella, '21°', '25°', 0.1, 0.5, isHighlighted: true),
          const SizedBox(height: 4),
          _buildDailyForecastItem('Thứ 6', 'Nắng ráo', Icons.wb_sunny, '22°', '27°', 0.4, 0.8),
        ],
      ),
    );
  }

  Widget _buildDailyForecastItem(
      String day, String condition, IconData icon, String minTemp, String maxTemp, double barStart, double barEnd,
      {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.white.withValues(alpha: 0.50) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              day,
              style: const TextStyle(
                color: Color(0xFF424754),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF424754), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    condition,
                    style: const TextStyle(
                      color: Color(0xFF424754),
                      fontSize: 12,
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
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
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
                      color: const Color(0xFFE2E8F0),
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
                                  color: const Color(0xFF0058BE),
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
                    style: const TextStyle(
                      color: Color(0xFF191C1E),
                      fontSize: 14,
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

  Widget _buildAirQualityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x19C2C6D6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Color(0xFF16A34A), size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chất lượng không khí',
                  style: TextStyle(
                    color: Color(0xFF191C1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '42 • Tốt (Vùng an toàn)',
                  style: TextStyle(
                    color: Color(0xFF424754),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
