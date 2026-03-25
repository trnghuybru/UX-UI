import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 135),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMapSection(),
                    const SizedBox(height: 16),
                    _buildFilterChips(),
                    const SizedBox(height: 16),
                    _buildAlertLevels(),
                    const SizedBox(height: 24),
                    _buildAlertHeader(),
                    const SizedBox(height: 24),
                    _buildAlertList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMapSection() {
    return Container(
      width: double.infinity,
      height: 450,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF0),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x19C2C6D6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x190058BE),
            blurRadius: 50,
            offset: Offset(0, 25),
            spreadRadius: -12,
          )
        ],
        image: const DecorationImage(
          image: NetworkImage("https://placehold.co/400x500"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Badges on map
          Positioned(
            left: 120,
            top: 150,
            child: _buildMapBadge('NGUY HIỂM CAO', const Color(0xFFB90538)),
          ),
          Positioned(
            left: 180,
            top: 250,
            child: _buildMapBadge('CẢNH BÁO', const Color(0xFFF97316)),
          ),
          Positioned(
            left: 200,
            top: 320,
            child: _buildMapBadge('THEO DÕI', const Color(0xFFEAB308)),
          ),

          // Map Control Buttons
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              spacing: 8,
              children: [
                _buildMapControlButton(Icons.layers_outlined),
                _buildMapControlButton(Icons.my_location),
                _buildMapControlButton(
                  Icons.map, 
                  backgroundColor: const Color(0xFF0058BE),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapBadge(String text, Color color) {
    return Column(
      children: [
        Icon(Icons.location_on, color: color, size: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 3,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControlButton(IconData icon, {Color backgroundColor = Colors.white, Color iconColor = const Color(0xFF5A5F6B)}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x19000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
          BoxShadow(color: Color(0x19000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildFilterChips() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChip('Cảnh báo', isActive: true),
            const SizedBox(width: 4),
            _buildChip('Gió bão'),
            const SizedBox(width: 4),
            _buildChip('Trú ẩn'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: isActive ? const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))] : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? const Color(0xFF191C1E) : const Color(0xB2191C1E),
          fontSize: 12,
          fontFamily: 'Manrope',
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAlertLevels() {
    return Column(
      spacing: 8,
      children: [
        _buildAlertLevelItem(const Color(0xFFB90538), 'MỨC ĐỘ 3', 'Nguy hiểm cao'),
        _buildAlertLevelItem(const Color(0xFFF97316), 'MỨC ĐỘ 2', 'Cảnh báo'),
        _buildAlertLevelItem(const Color(0xFFEAB308), 'MỨC ĐỘ 1', 'Theo dõi'),
      ],
    );
  }

  Widget _buildAlertLevelItem(Color color, String subtitle, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x19C2C6D6)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 0, spreadRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF727785),
                  fontSize: 10,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.50,
                  height: 1.5,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF191C1E),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Điểm cảnh báo',
              style: TextStyle(
                color: Color(0xFF191C1E),
                fontSize: 24,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.60,
                height: 1.33,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Danh sách khu vực cần theo dõi sát sao',
              style: TextStyle(
                color: Color(0xFF424754),
                fontSize: 14,
                fontFamily: 'Manrope',
                height: 1.43,
              ),
            ),
          ],
        ),
        const Text(
          'Xem tất cả',
          style: TextStyle(
            color: Color(0xFF0058BE),
            fontSize: 14,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertList() {
    return Column(
      spacing: 12,
      children: [
        _buildAlertListItem(
          location: 'Quảng Trị',
          issue: 'Lốc xoáy',
          issueColor: const Color(0xFFFFB2B7),
          issueTextColor: const Color(0xFF40000D),
          severity: 'Nguy hiểm cao',
          severityColor: const Color(0xFFB90538),
          iconBgColor: const Color(0xFFFFDADB),
          iconColor: const Color(0xFFB90538),
          icon: Icons.air,
        ),
        _buildAlertListItem(
          location: 'Đà Nẵng',
          issue: 'Sạt lở',
          issueColor: const Color(0xFFFFDDB2),
          issueTextColor: const Color(0xFF4D2400),
          severity: 'Cảnh báo',
          severityColor: const Color(0xFFF97316),
          iconBgColor: const Color(0xFFFFEDD5),
          iconColor: const Color(0xFFF97316),
          icon: Icons.landslide,
        ),
      ],
    );
  }

  Widget _buildAlertListItem({
    required String location,
    required String issue,
    required Color issueColor,
    required Color issueTextColor,
    required String severity,
    required Color severityColor,
    required Color iconBgColor,
    required Color iconColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    color: Color(0xFF191C1E),
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: issueColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        issue,
                        style: TextStyle(
                          color: issueTextColor,
                          fontSize: 12,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $severity',
                      style: TextStyle(
                        color: severityColor,
                        fontSize: 12,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5A5F6B)),
          ),
        ],
      ),
    );
  }
}
