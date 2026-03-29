import 'package:flutter/material.dart';

class CustomToggleBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelectedIndexChanged;

  const CustomToggleBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141A22) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(labels.length, (index) {
            final isActive = index == selectedIndex;
            return GestureDetector(
              onTap: () => onSelectedIndexChanged(index),
              child: Container(
                margin: EdgeInsets.only(left: index == 0 ? 0 : 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? Theme.of(context).cardColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0x0C000000),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: isActive ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
