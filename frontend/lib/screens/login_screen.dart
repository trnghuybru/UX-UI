import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import '../widgets/text_field.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

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
                          const SizedBox(height: 20),
                          _buildLogoArea(),
                          const SizedBox(height: 32),
                          _buildFormCard(context),
                          const SizedBox(height: 32),
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
      padding: const EdgeInsets.all(32),
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
            'Chào mừng trở lại',
            style: TextStyle(
              color: Color(0xFF191C1E),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.50,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng đăng nhập để tiếp tục',
            style: TextStyle(color: Color(0xFF424754), fontSize: 14),
          ),
          const SizedBox(height: 32),
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
          const CustomTextField(
            hintText: 'email@vi-du.com',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MẬT KHẨU',
                style: TextStyle(
                  color: Color(0xFF54647A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.20,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    color: Color(0xFF0058BE),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: '••••••••',
            icon: Icons.lock_outline,
            obscureText: !_isPasswordVisible,
            suffixIcon: _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixIconPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 32),
          _buildLoginButton(context),
          const SizedBox(height: 32),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildSocialRow(),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
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
              'Đăng nhập',
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

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0x4CC2C6D6), thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'HOẶC ĐĂNG NHẬP BẰNG',
            style: TextStyle(
              color: Color(0xFF727785),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0x4CC2C6D6), thickness: 1)),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildSocialButton(
            title: 'Facebook',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/733/733547.png',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSocialButton(
            title: 'Google',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/300/300221.png',
          ),
        ),
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
              Image.network(iconUrl, width: 20, height: 20),
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
          'Chưa có tài khoản? ',
          style: TextStyle(color: Color(0xFF424754), fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            );
          },
          child: const Text(
            'Đăng ký ngay',
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
