import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: Stack(
        children: [
          // Top right decoration
          Positioned(
            right: -50,
            top: -80,
            child: Container(
              width: 156,
              height: 338,
              decoration: ShapeDecoration(
                color: const Color(0x0C0058BE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
          // Bottom left decoration
          Positioned(
            left: -20,
            bottom: -50,
            child: Container(
              width: 117,
              height: 253,
              decoration: ShapeDecoration(
                color: const Color(0x192170E4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          // Logo Area
                          _buildLogoArea(),
                          const SizedBox(height: 24),
                          // Form Card
                          _buildFormCard(context),
                          const SizedBox(height: 24),
                          // Bottom Text
                          _buildBottomText(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoArea() {
    return Column(
      children: [
        // Logo icon placeholder
        Container(
          width: 56,
          height: 56,
          child: Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF0058BE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 30),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFB2C36),
                    border: Border.all(color: Colors.white, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'SÓNG CỨU HỘ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF155DFC),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.20,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Bảo vệ bạn trước mọi cơn bão',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF424754),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x19C2C6D6), width: 1.27),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 48,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Đăng ký tài khoản',
            style: TextStyle(
              color: Color(0xFF191C1E),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.50,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng điền thông tin để đăng ký',
            style: TextStyle(
              color: Color(0xFF424754),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          
          // Name
          const Text(
            'HỌ VÀ TÊN',
            style: TextStyle(
              color: Color(0xFF54647A),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            hintText: 'Nguyễn Văn A',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          
          // Email
          const Text(
            'EMAIL',
            style: TextStyle(
              color: Color(0xFF54647A),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            hintText: 'email@vi-du.com',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          
          // Password
          const Text(
            'MẬT KHẨU',
            style: TextStyle(
              color: Color(0xFF54647A),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            hintText: '••••••••',
            icon: Icons.lock_outline,
            obscureText: true,
            suffixIcon: Icons.visibility_off_outlined,
          ),
          const SizedBox(height: 16),

          // Confirm Password
          const Text(
            'XÁC NHẬN MẬT KHẨU',
            style: TextStyle(
              color: Color(0xFF54647A),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            hintText: '••••••••',
            icon: Icons.lock_outline,
            obscureText: true,
            suffixIcon: Icons.visibility_off_outlined,
          ),
          const SizedBox(height: 16),

          // Terms and Policy
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: true,
                  onChanged: (val) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: const Color(0xFF0058BE),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Tôi đồng ý với các ',
                        style: TextStyle(color: Color(0xFF424754), fontSize: 13, fontWeight: FontWeight.w500, height: 1.5),
                      ),
                      const TextSpan(
                        text: 'Điều khoản',
                        style: TextStyle(color: Color(0xFF0058BE), fontSize: 13, fontWeight: FontWeight.w700, height: 1.5),
                      ),
                      const TextSpan(
                        text: ' và ',
                        style: TextStyle(color: Color(0xFF424754), fontSize: 13, fontWeight: FontWeight.w500, height: 1.5),
                      ),
                      const TextSpan(
                        text: 'Chính sách',
                        style: TextStyle(color: Color(0xFF0058BE), fontSize: 13, fontWeight: FontWeight.w700, height: 1.5),
                      ),
                      const TextSpan(
                        text: '.',
                        style: TextStyle(color: Color(0xFF424754), fontSize: 13, fontWeight: FontWeight.w500, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Signup Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0058BE), Color(0xFF2170E4)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x260058BE),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: const Center(
                  child: Text(
                    'Đăng ký ngay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Or Signup With
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0x4CC2C6D6), thickness: 1)),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Text(
                      'HOẶC ĐĂNG KÝ BẰNG',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF727785),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Color(0x4CC2C6D6), thickness: 1)),
            ],
          ),
          const SizedBox(height: 20),
          // Social Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSocialButton(
                  title: 'Facebook',
                  // Using correct PNG urls to prevent SVG error
                  iconUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/512px-2021_Facebook_icon.svg.png',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialButton(
                  title: 'Google',
                  iconUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/512px-Google_%22G%22_logo.svg.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    IconData? suffixIcon,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC2C6D6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              obscureText: obscureText,
              style: const TextStyle(
                color: Color(0xFF191C1E),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFFC2C6D6),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, color: const Color(0xFFC2C6D6), size: 20),
        ],
      ),
    );
  }

  Widget _buildSocialButton({required String title, required String iconUrl}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x19C2C6D6), width: 1.27),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(iconUrl, width: 20, height: 20, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF191C1E),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomText(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        const Text(
          'Đã có tài khoản? ',
          style: TextStyle(
            color: Color(0xFF424754),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back to login screen
          },
          child: const Text(
            'Đăng nhập ngay',
            style: TextStyle(
              color: Color(0xFF0058BE),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
