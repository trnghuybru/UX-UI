import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import '../widgets/text_field.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  bool _isConfPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: Stack(
        children: [
          // Top right decoration
          Positioned(
            right: -100,
            top: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x330058BE), Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
          // Bottom left decoration
          Positioned(
            left: -80,
            bottom: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x262170E4), Color(0x00FFFFFF)],
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          _buildLogoArea(),
                          const SizedBox(height: 24),
                          _buildFormCard(context),
                          const SizedBox(height: 24),
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
    return const LogoWidget();
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
            style: TextStyle(color: Color(0xFF424754), fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Name
          _buildLabel('HỌ VÀ TÊN'),
          const SizedBox(height: 8),
          const CustomTextField(
            hintText: 'Nguyễn Văn A',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // Email
          _buildLabel('EMAIL'),
          const SizedBox(height: 8),
          const CustomTextField(
            hintText: 'email@vi-du.com',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),

          // Password
          _buildLabel('MẬT KHẨU'),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: '••••••••',
            icon: Icons.lock_outline,
            obscureText: !_isPasswordVisible,
            suffixIcon: _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixIconPressed: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password
          _buildLabel('XÁC NHẬN MẬT KHẨU'),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: '••••••••',
            icon: Icons.lock_outline,
            obscureText: !_isConfPasswordVisible,
            suffixIcon: _isConfPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixIconPressed: () {
              setState(() => _isConfPasswordVisible = !_isConfPasswordVisible);
            },
          ),
          const SizedBox(height: 16),

          // Terms and Policy
          _buildTermsRow(),
          const SizedBox(height: 24),

          // Signup Button
          _buildSignupButton(context),
          const SizedBox(height: 24),

          // Divider
          _buildSocialDivider(),
          const SizedBox(height: 20),

          // Social Buttons
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  title: 'Facebook',
                  iconUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/2023_Facebook_icon.svg/960px-2023_Facebook_icon.svg.png',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialButton(
                  title: 'Google',
                  iconUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF54647A),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.20,
      ),
    );
  }

  Widget _buildTermsRow() {
    return Row(
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
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: Color(0xFF424754),
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(text: 'Tôi đồng ý với các '),
                TextSpan(
                  text: 'Điều khoản',
                  style: TextStyle(
                    color: Color(0xFF0058BE),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' và '),
                TextSpan(
                  text: 'Chính sách',
                  style: TextStyle(
                    color: Color(0xFF0058BE),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return Container(
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
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
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
    );
  }

  Widget _buildSocialDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0x4CC2C6D6), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'HOẶC ĐĂNG KÝ BẰNG',
            style: TextStyle(
              color: Color(0xFF727785),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0x4CC2C6D6), thickness: 1)),
      ],
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
              Image.network(
                iconUrl,
                width: 20,
                height: 20,
                errorBuilder: (c, e, s) => const Icon(Icons.error, size: 20),
              ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Đã có tài khoản? ',
          style: TextStyle(color: Color(0xFF424754), fontSize: 14),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
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
