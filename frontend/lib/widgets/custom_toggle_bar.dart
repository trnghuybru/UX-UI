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
    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
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
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: isActive ? const Color(0xFF191C1E) : const Color(0xB2191C1E),
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
