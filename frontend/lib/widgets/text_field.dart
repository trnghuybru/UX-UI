import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;

  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC2C6D6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: const TextStyle(color: Color(0xFF191C1E), fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFFC2C6D6),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (suffixIcon != null)
            GestureDetector(
              onTap: onSuffixIconPressed,
              child: Icon(suffixIcon, color: const Color(0xFFC2C6D6), size: 20),
            ),
        ],
      ),
    );
  }
}
