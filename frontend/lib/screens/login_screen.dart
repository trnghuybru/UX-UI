import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import '../widgets/text_field.dart';
import 'signup_screen.dart';
import '../widgets/shell_screen.dart';
import '../services/auth_service.dart';
import '../services/user_session.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ email và mật khẩu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final AuthResponse? response = await _authService.login(email, password);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response != null) {
          // Save session
          UserSession().saveSession(response);
          
          // Success: Navigation to ShellScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ShellScreen()),
          );
        } else {
          // Failure: Display error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.27),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0x07000000),
            blurRadius: 48,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chào mừng trở lại',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng đăng nhập để tiếp tục',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
          ),
          const SizedBox(height: 32),
          Text(
            'EMAIL',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'email@vi-du.com',
            icon: Icons.email_outlined,
            controller: _emailController,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MẬT KHẨU',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.20,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
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
            controller: _passwordController,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryDimColor = isDark ? const Color(0xFF0F6DF3) : const Color(0xFF2170E4);

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, primaryDimColor],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleLogin,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
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
        Expanded(child: Divider(color: Theme.of(context).dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'HOẶC ĐĂNG NHẬP BẰNG',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.20,
            ),
          ),
        ),
        Expanded(child: Divider(color: Theme.of(context).dividerColor, thickness: 1)),
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.27),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
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
        Text(
          'Chưa có tài khoản? ',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            );
          },
          child: Text(
            'Đăng ký ngay',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
