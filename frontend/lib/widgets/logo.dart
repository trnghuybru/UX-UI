import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 60,
          child: Stack(
            children: [
              CustomPaint(size: const Size(80, 60), painter: WaveLogoPainter()),
              Positioned(
                right: 12,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFB2C36),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'SÓNG CỨU HỘ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF155DFC),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.20,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Bảo vệ bạn trước mọi cơn bão',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF424754),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class WaveLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF155DFC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final yOffset = 20.0 + (i * 15.0);
      final path = Path();
      path.moveTo(size.width * 0.1, yOffset);

      path.quadraticBezierTo(
        size.width * 0.25,
        yOffset - 8,
        size.width * 0.45,
        yOffset,
      );
      path.quadraticBezierTo(
        size.width * 0.65,
        yOffset + 8,
        size.width * 0.85,
        yOffset,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
