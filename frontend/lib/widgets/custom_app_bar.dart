import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationPressed;

  const CustomAppBar({super.key, this.onNotificationPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF7F9FB),
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Row(
        children: [
          Icon(Icons.waves, color: Color(0xFF0058BE)),
          SizedBox(width: 8),
          Text(
            'Sóng Cứu Hộ',
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
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF424754)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Color(0xFF424754)),
          onPressed: onNotificationPressed ?? () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
