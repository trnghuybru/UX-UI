import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_toggle_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedFilterIndex = 0;


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
                    _buildDynamicMapSection(),
                    const SizedBox(height: 16),
                    CustomToggleBar(
                      labels: const ['Cảnh báo', 'Gió bão', 'Trú ẩn'],
                      selectedIndex: _selectedFilterIndex,
                      onSelectedIndexChanged: (index) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDynamicContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDynamicMapSection() {
    if (_selectedFilterIndex == 1) {
      return _buildStormMapSection();
    } else if (_selectedFilterIndex == 2) {
      return _buildShelterMapSection();
    }
    return _buildNormalMapSection();
  }

  Widget _buildNormalMapSection() {
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

  Widget _buildStormMapSection() {
    return Container(
      width: double.infinity,
      height: 340,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140058BE),
            blurRadius: 32,
            offset: Offset(0, 12),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://placehold.co/358x340",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xE5F7F9FB), Color(0x00F7F9FB), Color(0x00F7F9FB), Color(0xE5F7F9FB)],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFB90538),
                shape: BoxShape.circle,
                border: Border.all(width: 4, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              spacing: 8,
              children: [
                _buildMapControlButton(Icons.add),
                _buildMapControlButton(Icons.remove),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelterMapSection() {
    return Container(
      width: double.infinity,
      height: 320,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF0),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage("https://placehold.co/400x320"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 100,
            top: 80,
            child: _buildShelterMapBadge('THPT LÊ QUÝ ĐÔN'),
          ),
          Positioned(
            left: 200,
            top: 160,
            child: _buildShelterMapBadge('NHÀ VĂN HÓA'),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4C2E7D32),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    )
                  ],
                ),
                child: const Text(
                  'Đăng ký địa điểm trú ẩn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelterMapBadge(String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFF2E7D32),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x4CFFFFFF),
                blurRadius: 0,
                spreadRadius: 4,
              )
            ],
          ),
          child: const Icon(Icons.home, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))
            ],
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 10,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicContent() {
    if (_selectedFilterIndex == 0) {
      // Tab Cảnh báo
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAlertLevels(),
          const SizedBox(height: 24),
          _buildAlertHeader(),
          const SizedBox(height: 24),
          _buildAlertList(),
        ],
      );
    } else if (_selectedFilterIndex == 1) {
      // Tab Gió bão
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStormWarningCard(),
          const SizedBox(height: 16),
          _buildIntensityZonesCard(),
          const SizedBox(height: 16),
          _buildRouteUpdateInfo(),
        ],
      );
    } else {
      // Tab Trú ẩn
      return _buildShelterTabContent();
    }
  }

  // --- TAB CẢNH BÁO --- //
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
  // --- TAB GIÓ BÃO --- //
  Widget _buildStormWarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x19C2C6D6)),
        boxShadow: const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'CẢNH BÁO KHẨN CẤP',
                    style: TextStyle(
                      color: Color(0xFFB90538),
                      fontSize: 12,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bão số 5',
                    style: TextStyle(
                      color: Color(0xFF191C1E),
                      fontSize: 30,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.75,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDADB),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB90538),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Đang hoạt động',
                      style: TextStyle(
                        color: Color(0xFFB90538),
                        fontSize: 12,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 12,
            children: [
              Expanded(child: _buildStormStatCard('SỨC GIÓ', '120', 'km/h')),
              Expanded(child: _buildStormStatCard('HƯỚNG', 'Tây Bắc', '')),
              Expanded(child: _buildStormStatCard('ÁP SUẤT', '960', 'hPa')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStormStatCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF505F76),
              fontSize: 10,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: -0.50,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF191C1E),
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      color: Color(0xFF191C1E),
                      fontSize: 10,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntensityZonesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PHÂN VÙNG CƯỜNG ĐỘ',
            style: TextStyle(
              color: Color(0xFF424754),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.70,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            spacing: 12,
            children: [
              _buildZoneItem('Tâm bão', 'Cực nguy hiểm', const Color(0xFFB90538)),
              _buildZoneItem('Vùng gần tâm', 'Rất nguy hiểm', const Color(0xFFDC2C4F)),
              _buildZoneItem('Vùng ảnh hưởng', 'Nguy hiểm', const Color(0xFFF97316)),
              _buildZoneItem('Vùng ngoại vi', 'Cảnh báo', const Color(0xFFFACC15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneItem(String title, String level, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF191C1E),
                  fontSize: 12,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                level,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteUpdateInfo() {
    return Opacity(
      opacity: 0.60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFB90538)),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'LỘ TRÌNH DỰ KIẾN',
                  style: TextStyle(
                    color: Color(0xFF191C1E),
                    fontSize: 10,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Icon(Icons.access_time, size: 12, color: Color(0xFF191C1E)),
                SizedBox(width: 4),
                Text(
                  'CẬP NHẬT: 5 PHÚT TRƯỚC',
                  style: TextStyle(
                    color: Color(0xFF191C1E),
                    fontSize: 10,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB TRÚ ẨN --- //
  Widget _buildShelterTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShelterHeader(),
        const SizedBox(height: 16),
        _buildShelterCard(
          name: 'Trường THPT Lê Quý Đôn',
          location: 'Đông Hà, Quảng Trị',
          statusText: 'Đang mở',
          statusColor: const Color(0xFF2E7D32),
          currentCapacity: 450,
          maxCapacity: 600,
          facilities: ['Nước uống', 'Chăn màn', 'Y tế cơ bản'],
          distance: '1.2 km',
          time: '5 phút',
          method: 'Đi bộ',
        ),
        const SizedBox(height: 16),
        _buildShelterCard(
          name: 'Nhà Văn hóa Thôn 4',
          location: 'Triệu Phong, Quảng Trị',
          statusText: 'Sắp đầy',
          statusColor: const Color(0xFFEAB308),
          currentCapacity: 180,
          maxCapacity: 200,
          facilities: ['Nước uống'],
          distance: '2.5 km',
          time: '10 phút',
          method: 'Xe máy',
        ),
      ],
    );
  }

  Widget _buildShelterHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: const [
        Text(
          'Điểm trú ẩn an toàn',
          style: TextStyle(
            color: Color(0xFF191C1E),
            fontSize: 24,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            height: 1.33,
            letterSpacing: -0.60,
          ),
        ),
        Text(
          'Tìm nơi tạm trú gần nhất trong tình huống khẩn cấp',
          style: TextStyle(
            color: Color(0xFF424754),
            fontSize: 14,
            fontFamily: 'Manrope',
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _buildShelterCard({
    required String name,
    required String location,
    required String statusText,
    required Color statusColor,
    required int currentCapacity,
    required int maxCapacity,
    required List<String> facilities,
    required String distance,
    required String time,
    required String method,
  }) {
    double fillPercentage = (currentCapacity / maxCapacity).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x19C2C6D6)),
        boxShadow: const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0E1FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.home_work, color: Color(0xFF0058BE), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Color(0xFF191C1E),
                              fontSize: 18,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Color(0xFF424754),
                              fontSize: 14,
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SỨC CHỨA HIỆN TẠI',
                      style: TextStyle(
                        color: Color(0xFF424754),
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$currentCapacity',
                          style: const TextStyle(
                            color: Color(0xFF0058BE),
                            fontSize: 20,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            ' / $maxCapacity người',
                            style: const TextStyle(
                              color: Color(0xFF424754),
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 96,
                  height: 8,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECEEF0),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 96 * fillPercentage,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0058BE),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'TIỆN NGHI CÓ SẴN',
            style: TextStyle(
              color: Color(0xFF424754),
              fontSize: 10,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facilities.map((e) => _buildFacilityTag(e)).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'CHI TIẾT',
            style: TextStyle(
              color: Color(0xFF424754),
              fontSize: 10,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 16,
            children: [
              _buildDetailItem(Icons.route, distance),
              _buildDetailItem(Icons.access_time, time),
              _buildDetailItem(Icons.directions_walk, method),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  text: 'Gọi hỗ trợ',
                  icon: Icons.phone,
                  color: const Color(0xFF191C1E),
                  backgroundColor: const Color(0xFFF2F4F6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  text: 'Chỉ đường',
                  icon: Icons.directions,
                  color: Colors.white,
                  backgroundColor: const Color(0xFF0058BE),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityTag(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Color(0xFF191C1E),
          fontSize: 12,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF5A5F6B)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF191C1E),
            fontSize: 12,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
