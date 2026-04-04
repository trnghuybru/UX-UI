import 'package:flutter/material.dart';
import '../main.dart'; // import themeNotifier
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationPressed;
  final String? title;

  const CustomAppBar({super.key, this.onNotificationPressed, this.title});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = Theme.of(context).colorScheme.onSurface;
    final titleColor = Theme.of(context).colorScheme.primary;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Navigator.canPop(context) 
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: iconColor, size: 20),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: title != null 
        ? Text(
            title!,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF191C1E),
              fontSize: 18,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          )
        : Row(
            children: [
              Icon(Icons.waves, color: titleColor),
              const SizedBox(width: 8),
              Text(
                'Sóng Cứu Hộ',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.50,
                ),
              ),
            ],
          ),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return IconButton(
              icon: Icon(
                currentMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                color: iconColor,
              ),
              onPressed: () {
                themeNotifier.value =
                    currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.search, color: iconColor),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: iconColor),
          onPressed: onNotificationPressed ?? () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
