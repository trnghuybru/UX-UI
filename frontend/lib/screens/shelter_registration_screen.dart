import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class ShelterRegistrationScreen extends StatefulWidget {
  const ShelterRegistrationScreen({super.key});

  @override
  State<ShelterRegistrationScreen> createState() => _ShelterRegistrationScreenState();
}

class _ShelterRegistrationScreenState extends State<ShelterRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController(text: '50');
  final TextEditingController _currentController = TextEditingController(text: '0');
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _hasWater = true;
  bool _hasFood = false;
  bool _hasMedical = false;
  bool _hasElectricity = false;
  bool _hasWifi = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sectionTitleColor = isDark ? const Color(0xFFA8ABB3) : const Color(0xFF54647A);
    final Color inputBgColor = isDark ? const Color(0xFF1D2024) : Colors.white;
    final Color textColor = isDark ? const Color(0xFFF1F3FC) : const Color(0xFF191C1E);
    final Color subTextColor = isDark ? const Color(0x99A8ABB3) : const Color(0xFF64748B);
    final Color accentColor = isDark ? const Color(0xFF89ACFF) : const Color(0xFF0058BE);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E14) : const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 80, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_location_alt_rounded, color: accentColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Đăng ký Địa điểm',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Section 1: Basic Information
            _buildSectionHeader(context, 'THÔNG TIN CƠ BẢN', Icons.info_outline_rounded, sectionTitleColor),
            const SizedBox(height: 16),
            _buildInputField(
              label: 'Tên địa điểm',
              hint: 'Ví dụ: Nhà văn hóa Cộng đồng',
              controller: _nameController,
              isDark: isDark,
              inputBgColor: inputBgColor,
              subTextColor: subTextColor,
              textColor: textColor,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: 'Địa chỉ',
              hint: 'Nhập địa chỉ chính xác',
              controller: _addressController,
              isDark: isDark,
              inputBgColor: inputBgColor,
              subTextColor: subTextColor,
              textColor: textColor,
              suffixIcon: Icons.my_location_rounded,
            ),
            const SizedBox(height: 32),

            // Section 2: Capacity
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F141A) : const Color(0xFFF2F4F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                   _buildSectionHeader(context, 'KHẢ NĂNG TIẾP NHẬN', Icons.people_outline_rounded, sectionTitleColor),
                   const SizedBox(height: 16),
                   _buildCapacityCard(
                     label: 'SỨC CHỨA TỐI ĐA',
                     value: _capacityController.text,
                     unit: 'Người',
                     isDark: isDark,
                     accentColor: accentColor,
                     cardColor: inputBgColor,
                   ),
                   const SizedBox(height: 12),
                   _buildCapacityCard(
                     label: 'SỐ NGƯỜI HIỆN CÓ',
                     value: _currentController.text,
                     unit: 'Người',
                     isDark: isDark,
                     accentColor: isDark ? textColor : Colors.black87,
                     cardColor: inputBgColor,
                   ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section 3: Amenities
            _buildSectionHeader(context, 'TIỆN NGHI CÓ SẴN', Icons.check_circle_outline_rounded, sectionTitleColor),
            const SizedBox(height: 16),
            _buildAmenityTile(
              label: 'Nước sạch',
              icon: Icons.water_drop_rounded,
              value: _hasWater,
              onChanged: (v) => setState(() => _hasWater = v),
              isDark: isDark,
              accentColor: accentColor,
              cardColor: inputBgColor,
              textColor: textColor,
            ),
            const SizedBox(height: 12),
            _buildAmenityTile(
              label: 'Thực phẩm',
              icon: Icons.restaurant_rounded,
              value: _hasFood,
              onChanged: (v) => setState(() => _hasFood = v),
              isDark: isDark,
              accentColor: accentColor,
              cardColor: inputBgColor,
              textColor: textColor,
            ),
            const SizedBox(height: 12),
            _buildAmenityTile(
              label: 'Y tế sơ cứu',
              icon: Icons.medical_services_rounded,
              value: _hasMedical,
              onChanged: (v) => setState(() => _hasMedical = v),
              isDark: isDark,
              accentColor: accentColor,
              cardColor: inputBgColor,
              textColor: textColor,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSmallAmenityTile(
                    label: 'Điện',
                    value: _hasElectricity,
                    onChanged: (v) => setState(() => _hasElectricity = v),
                    isDark: isDark,
                    cardColor: inputBgColor,
                    textColor: textColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallAmenityTile(
                    label: 'Wifi',
                    value: _hasWifi,
                    onChanged: (v) => setState(() => _hasWifi = v),
                    isDark: isDark,
                    cardColor: inputBgColor,
                    textColor: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Section 4: Real Photos
            _buildSectionHeader(context, 'ẢNH CHỤP THỰC TẾ', Icons.camera_alt_outlined, sectionTitleColor),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE2E8F0),
                        width: 2,
                        style: BorderStyle.solid, // Custom paint would be needed for dashed
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: subTextColor, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          'TẢI ẢNH LÊN',
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 10,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage("https://placehold.co/173x173"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Section 5: Contact
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(24),
                border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
                boxShadow: !isDark ? const [
                  BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4)),
                ] : null,
              ),
              child: Column(
                children: [
                  _buildSectionHeader(context, 'THÔNG TIN LIÊN HỆ', Icons.contact_phone_outlined, sectionTitleColor),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'Họ tên chủ hộ/Quản lý',
                    hint: 'Nhập họ và tên',
                    controller: _contactNameController,
                    isDark: isDark,
                    inputBgColor: isDark ? const Color(0xFF0F141A) : const Color(0xFFF7F9FB),
                    subTextColor: subTextColor,
                    textColor: textColor,
                    noShadow: true,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'Số điện thoại',
                    hint: 'Nhập số điện thoại linh hoạt',
                    controller: _phoneController,
                    isDark: isDark,
                    inputBgColor: isDark ? const Color(0xFF0F141A) : const Color(0xFFF7F9FB),
                    subTextColor: subTextColor,
                    textColor: textColor,
                    noShadow: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Hoàn tất Đăng ký',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color titleColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: titleColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 12,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    required Color inputBgColor,
    required Color subTextColor,
    required Color textColor,
    IconData? suffixIcon,
    bool noShadow = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: subTextColor,
            fontSize: 12,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: (!isDark && !noShadow) ? const [
               BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1)),
            ] : null,
            border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.1)) : null,
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: subTextColor.withValues(alpha: 0.6), fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: subTextColor, size: 20) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCapacityCard({
    required String label,
    required String value,
    required String unit,
    required bool isDark,
    required Color accentColor,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: !isDark ? const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1)),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? const Color(0x99A8ABB3) : const Color(0xFF94A3B8),
              fontSize: 10,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                unit,
                style: TextStyle(
                  color: isDark ? const Color(0x99A8ABB3) : const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityTile({
    required String label,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
    required Color accentColor,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: !isDark ? const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1)),
        ] : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAmenityTile({
    required String label,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: !isDark ? const [
            BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1)),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF0058BE) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? const Color(0xFF0058BE) : (isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE2E8F0)),
                  width: 1.5,
                ),
              ),
              child: value ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
