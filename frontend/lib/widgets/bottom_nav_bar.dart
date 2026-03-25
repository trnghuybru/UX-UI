import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/sos_screen.dart';
import '../screens/news_screen.dart';
import '../screens/profile_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  
  const CustomBottomNavBar({super.key, this.selectedIndex = 0});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;
    Widget? page;
    if (index == 0) page = const HomeScreen();
    if (index == 1) page = const MapScreen();
    if (index == 2) page = const NewsScreen();
    if (index == 3) page = const SosScreen();
    if (index == 4) page = const ProfileScreen();

    if (page != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => page!,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SafeArea( // Đảm bảo an toàn không bị lẹm vào phần viền màn hình
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavItem(context, icon: Icons.cloud_outlined, label: 'DỰ BÁO', index: 0),
            _buildNavItem(context, icon: Icons.map_outlined, label: 'BẢN ĐỒ', index: 1),
            _buildNavItem(context, icon: Icons.article_outlined, label: 'TIN TỨC', index: 2),
            _buildSosItem(context, index: 3),
            _buildNavItem(context, icon: Icons.person_outline, label: 'CÁ NHÂN', index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {
    required IconData icon, 
    required String label, 
    required int index,
  }) {
    bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: ShapeDecoration(
          color: isActive ? const Color(0xFFDEE9F5) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF0058BE) : const Color(0xFF5A5F6B),
              size: 24,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? const Color(0xFF0058BE) : const Color(0xFF5A5F6B),
                  fontSize: 11,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                  letterSpacing: 0.28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSosItem(BuildContext context, {required int index}) {
    bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFDC2C4F),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('SOS', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              )
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'SOS',
                style: TextStyle(
                  color: isActive ? const Color(0xFFDC2C4F) : const Color(0xFF5A5F6B),
                  fontSize: 11,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                  letterSpacing: 0.28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

