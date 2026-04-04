import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0C10) : Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategories(isDark),
            const SizedBox(height: 24),
            _buildEmergencyNewsCard(isDark),
            const SizedBox(height: 24),
            _buildNormalNewsCard(
              isDark: isDark,
              tag: 'CẢNH BÁO NGẬP',
              tagColor: const Color(0xFFFFB3B8),
              title: 'Danh sách các điểm ngập tại Hà Nội sáng\nnay',
              time: '15 phút trước',
              imageUrl: 'https://placehold.co/356x160',
            ),
            const SizedBox(height: 16),
            _buildNormalNewsCard(
              isDark: isDark,
              tag: 'DỰ BÁO TUẦN',
              tagColor: const Color(0xFFADC6FF),
              title: 'Dự báo thời tiết 7 ngày tới: Mưa diện rộng\nkéo dài',
              time: '2 giờ trước',
              imageUrl: 'https://placehold.co/356x160',
            ),
            const SizedBox(height: 16),
            _buildSafetyGuideCard(isDark),
            const SizedBox(height: 16),
            _buildNormalNewsCard(
              isDark: isDark,
              tag: 'CẬP NHẬT',
              tagColor: isDark ? const Color(0x99E2E2E6) : const Color(0xFF64748B),
              title: 'Lượng mưa tại các tỉnh miền núi phía Bắc\ntăng mạnh',
              time: '5 giờ trước',
              imageUrl: 'https://placehold.co/356x160',
            ),
            const SizedBox(height: 16),
            _buildNormalNewsCard(
              isDark: isDark,
              tag: 'CỨU NẠN',
              tagColor: const Color(0xFFFFB3B8),
              title: 'Kích hoạt đội phản ứng nhanh hỗ trợ vùng\nrốn lũ',
              time: '8 giờ trước',
              imageUrl: 'https://placehold.co/356x160',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryPill('Tất cả', isDark: isDark, isActive: true),
          const SizedBox(width: 8),
          _buildCategoryPill('Cảnh báo bão', isDark: isDark),
          const SizedBox(width: 8),
          _buildCategoryPill('Ngập lụt', isDark: isDark),
          const SizedBox(width: 8),
          _buildCategoryPill('Kỹ năng', isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String text, {required bool isDark, bool isActive = false}) {
    final Color activeBg = isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE);
    final Color inactiveBg = isDark ? const Color(0xFF282A2F) : const Color(0xFFF2F4F6);
    final Color activeText = isDark ? const Color(0xFF0A0C10) : Colors.white;
    final Color inactiveText = isDark ? const Color(0xCCE2E2E6) : const Color(0xFF191C1E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? activeBg : inactiveBg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? activeText : inactiveText,
          fontSize: 14,
          fontFamily: 'Manrope',
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          height: 1.43,
        ),
      ),
    );
  }

  Widget _buildEmergencyNewsCard(bool isDark) {
    final Color bgColor = isDark ? const Color(0xFF930022) : const Color(0xFFDC2C4F);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.10)) : null,
        boxShadow: isDark
            ? const [
                BoxShadow(
                  color: Color(0x7F000000),
                  blurRadius: 50,
                  offset: Offset(0, 25),
                  spreadRadius: -12,
                )
              ]
            : const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 10,
                  offset: Offset(0, 8),
                  spreadRadius: -6,
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 25,
                  offset: Offset(0, 20),
                  spreadRadius: -5,
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'TIN KHẨN CẤP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                    letterSpacing: 0.50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bão số 5 (Koinu) đang tiến\nsát đất liền miền Trung',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Dự báo gây mưa lớn và gió giật mạnh từ\nQuảng Bình đến Đà Nẵng trong 24h tới.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.70),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark ? const [
                BoxShadow(color: Color(0x19000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
                BoxShadow(color: Color(0x19000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
              ] : null,
            ),
            child: Text(
              'Xem chi tiết',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: bgColor,
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalNewsCard({
    required bool isDark,
    required String tag,
    required Color tagColor,
    required String title,
    required String time,
    required String imageUrl,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D2024) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
        boxShadow: !isDark ? const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                opacity: 0.90,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black.withValues(alpha: 0.60) : Colors.white.withValues(alpha: 0.90),
                      borderRadius: BorderRadius.circular(8),
                      border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.10)) : null,
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: tagColor,
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFE2E2E6) : const Color(0xFF191C1E),
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  time,
                  style: TextStyle(
                    color: isDark ? const Color(0x66E2E2E6) : const Color(0xFF94A3B8),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyGuideCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF004494) : const Color(0xFF2170E4),
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CẨM NANG AN TOÀN',
                  style: TextStyle(
                    color: isDark ? const Color(0x99D8E2FF) : Colors.white.withValues(alpha: 0.60),
                    fontSize: 10,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hướng dẫn ứng phó\nkhi xảy ra lũ quét và\nsạt lở đất',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Đọc ngay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.43,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.10),
              borderRadius: BorderRadius.circular(16),
              border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.10)) : null,
            ),
            child: const Icon(Icons.book, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}
