import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _safeModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 48, left: 16, right: 16),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildContactInfo(),
              const SizedBox(height: 16),
              _buildQuickSettings(),
              const SizedBox(height: 24),
              _buildAdvancedMenu(),
              const SizedBox(height: 32),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 4),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Background decorative circle
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: const Color(0x0C0058BE),
                  shape: BoxShape.circle,
                ),
              ),
              // Main Avatar
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF7F9FB), width: 4),
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/96x96"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x19000000), blurRadius: 6, offset: Offset(0, 4)),
                  ],
                ),
              ),
              // Camera Badge
              Positioned(
                bottom: 0,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0058BE),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Nguyễn Văn A',
            style: TextStyle(
              color: Color(0xFF191C1E),
              fontSize: 24,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
              height: 1.33,
              letterSpacing: -0.60,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'nguyenvana@email.com',
            style: TextStyle(
              color: Color(0xFF54647A),
              fontSize: 14,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
              borderRadius: BorderRadius.circular(9999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E8EA),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.edit_outlined, size: 18, color: Color(0xFF191C1E)),
                    SizedBox(width: 8),
                    Text(
                      'Chỉnh sửa hồ sơ',
                      style: TextStyle(
                        color: Color(0xFF191C1E),
                        fontSize: 14,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THÔNG TIN LIÊN HỆ',
            style: TextStyle(
              color: Color(0xFF54647A),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.70,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone_outlined, 'SỐ ĐIỆN THOẠI', '+84 123 456 789'),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on_outlined, 'ĐỊA CHỈ', 'Quận 1, TP. Hồ Chí Minh'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0058BE), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.28,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF191C1E),
                  fontSize: 16,
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

  Widget _buildQuickSettings() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CÀI ĐẶT NHANH',
            style: TextStyle(
              color: Color(0xFF54647A),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.70,
            ),
          ),
          const SizedBox(height: 8),
          _buildSwitchRow(
            icon: Icons.notifications_none,
            label: 'Thông báo',
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          _buildSwitchRow(
            icon: Icons.my_location_outlined,
            label: 'Vị trí',
            value: _locationEnabled,
            onChanged: (val) {
              setState(() {
                _locationEnabled = val;
              });
            },
          ),
          _buildSwitchRow(
            icon: Icons.shield_outlined,
            label: 'Chế độ an toàn',
            value: _safeModeEnabled,
            onChanged: (val) {
              setState(() {
                _safeModeEnabled = val;
              });
            },
            isWarning: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isWarning = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0x0CB90538) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isWarning ? Border.all(color: const Color(0x19B90538)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: isWarning ? const Color(0xFFB90538) : const Color(0xFF5A5F6B)),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isWarning ? const Color(0xFFB90538) : const Color(0xFF191C1E),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: isWarning ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF0058BE),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE0E3E5),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedMenu() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildMenuItem(Icons.history, 'Lịch sử cảnh báo', true),
          _buildMenuItem(Icons.contact_phone_outlined, 'Danh bạ khẩn cấp', true),
          _buildMenuItem(Icons.settings_outlined, 'Cài đặt nâng cao', true),
          _buildMenuItem(Icons.privacy_tip_outlined, 'Quyền riêng tư', false),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, bool showDivider) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider 
            ? const Border(bottom: BorderSide(color: Color(0x19F7F9FB)))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: const Color(0xFF0058BE), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF191C1E),
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle logout
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0x19DC2C4F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x33DC2C4F)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Color(0xFFDC2C4F)),
            SizedBox(width: 8),
            Text(
              'Đăng xuất',
              style: TextStyle(
                color: Color(0xFFDC2C4F),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
