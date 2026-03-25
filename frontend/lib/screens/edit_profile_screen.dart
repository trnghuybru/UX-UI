import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatarEditor(),
                    const SizedBox(height: 40),
                    _buildFormFields(),
                    const SizedBox(height: 40),
                    _buildDeleteAccountButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 4),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color(0xFFF7F9FB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF191C1E)),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Chỉnh sửa hồ sơ',
                style: TextStyle(
                  color: Color(0xFF0058BE),
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.50,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              // Save action
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF), // A subtle blue background for Save button
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Lưu',
                style: TextStyle(
                  color: Color(0xFF0058BE),
                  fontSize: 14,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatarEditor() {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/120x120"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0058BE),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Thay đổi ảnh đại diện',
            style: TextStyle(
              color: Color(0xFF0058BE),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildInputField(label: 'HỌ VÀ TÊN', initialValue: 'Nguyễn Văn A'),
        const SizedBox(height: 16),
        _buildInputField(label: 'EMAIL', initialValue: 'vana.nguyen@email.com'),
        const SizedBox(height: 16),
        _buildInputField(label: 'SỐ ĐIỆN THOẠI', initialValue: '090 123 4567'),
        const SizedBox(height: 16),
        _buildInputField(
            label: 'ĐỊA CHỈ',
            initialValue: '123 Đường Lê Lợi, Quận 1, TP. HCM',
            suffixIcon: Icons.location_on_outlined),
        const SizedBox(height: 16),
        _buildInputField(
            label: 'NGÀY SINH',
            initialValue: '15/05/1990',
            suffixIcon: Icons.calendar_today_outlined),
      ],
    );
  }

  Widget _buildInputField({required String label, required String initialValue, IconData? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF424754),
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.60,
            ),
          ),
        ),
        TextFormField(
          initialValue: initialValue,
          style: const TextStyle(
            color: Color(0xFF191C1E),
            fontSize: 16,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF94A3B8), size: 20) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x26C2C6D6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Delete account action
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_remove_outlined, color: Color(0xFFB90538), size: 20),
                SizedBox(width: 8),
                Text(
                  'Xóa tài khoản',
                  style: TextStyle(
                    color: Color(0xFFB90538),
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
