import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  
  const CustomBottomNavBar({super.key, this.selectedIndex = 0});

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
            _buildNavItem(icon: Icons.cloud_outlined, label: 'DỰ BÁO', isActive: selectedIndex == 0),
            _buildNavItem(icon: Icons.map_outlined, label: 'BẢN ĐỒ', isActive: selectedIndex == 1),
            _buildNavItem(icon: Icons.article_outlined, label: 'TIN TỨC', isActive: selectedIndex == 2),
            _buildNavItem(icon: Icons.warning_amber_rounded, label: 'SOS', isActive: selectedIndex == 3),
            _buildNavItem(icon: Icons.person_outline, label: 'CÁ NHÂN', isActive: selectedIndex == 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon, 
    required String label, 
    required bool isActive,
  }) {
    return Container(
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
    );
  }
}
