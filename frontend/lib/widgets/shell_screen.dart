import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/sos_screen.dart';
import '../screens/news_screen.dart';
import '../screens/profile_screen.dart';

/// Shell keeps all screens alive via IndexedStack — no rebuild on tab switch
class ShellScreen extends StatefulWidget {
  static final GlobalKey<ShellScreenState> shellKey = GlobalKey<ShellScreenState>();
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => ShellScreenState();
}

class ShellScreenState extends State<ShellScreen> {
  int _selectedIndex = 0;

  void setTab(int index) {
    if (_selectedIndex != index) setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeScreen(),
          MapScreen(),
          NewsScreen(),
          SosScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        selectedIndex: _selectedIndex,
        onTap: setTab,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFF141A22).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.9);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _item(context, Icons.cloud_outlined, 'DỰ BÁO', 0),
                _item(context, Icons.map_outlined, 'BẢN ĐỒ', 1),
                _item(context, Icons.article_outlined, 'TIN TỨC', 2),
                _sosItem(context),
                _item(context, Icons.person_outline, 'CÁ NHÂN', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: ShapeDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: 0.28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sosItem(BuildContext context) {
    final isActive = selectedIndex == 3;
    return GestureDetector(
      onTap: () => onTap(3),
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('SOS',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'SOS',
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.5,
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
