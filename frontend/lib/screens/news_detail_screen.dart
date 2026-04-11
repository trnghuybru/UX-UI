import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String time;
  final String source;
  final String category;

  const NewsDetailScreen({
    super.key,
    this.title = 'Cảnh báo ngập lụt tại các tỉnh miền Trung',
    this.time = '5 giờ trước',
    this.source = 'Đài Khí tượng Thủy văn khu vực',
    this.category = 'CẢNH BÁO',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0058BE)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sóng Cứu Hộ',
          style: GoogleFonts.montserrat(
            color: const Color(0xFF0058BE),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Color(0xFF5A5F6B)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_border_rounded, color: Color(0xFF5A5F6B)), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MAIN HEADER CARD
            _buildMainHeader(),
            const SizedBox(height: 24),

            // ALERT LEVEL
            _buildSectionCard(
              title: 'MỨC ĐỘ CẢNH BÁO',
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0x19B90538),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.warning_rounded, color: Color(0xFFB90538), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cấp độ 3',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFFB90538),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Nguy Hiểm',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF505F76),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // AFFECTED AREAS
            _buildSectionCard(
              title: 'KHU VỰC ẢNH HƯỞNG',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildAreaTag('Quảng Bình'),
                  _buildAreaTag('Quảng Trị'),
                  _buildAreaTag('Thừa Thiên Huế'),
                  _buildAreaTag('Đà Nẵng'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // DETAILS
            _buildSectionCard(
              title: 'CHI TIẾT TÌNH HÌNH',
              icon: Icons.description_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Do ảnh hưởng của rãnh áp thấp kết hợp với gió mùa đông bắc cường độ mạnh, khu vực miền Trung đang ghi nhận lượng mưa cực lớn. Mực nước tại các hệ thống sông chính đang lên rất nhanh, vượt mức báo động 3.',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF424754),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0x0CB90538),
                      border: Border(
                        left: BorderSide(color: Color(0xFFB90538), width: 4),
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cảnh báo lũ quét và sạt lở đất tại các vùng núi cao. Người dân cần chủ động phương án sơ tán ngay khi có lệnh.',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFFB90538),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SAFETY GUIDES
            Text(
              'Hướng dẫn an toàn',
              style: GoogleFonts.montserrat(
                color: const Color(0xFF191C1E),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            _buildSafetyGuideList(
              title: 'NÊN LÀM',
              color: const Color(0xFF059669),
              icon: Icons.check_circle_outline,
              items: [
                'Theo dõi bản tin dự báo thời tiết thường xuyên trên đài, báo.',
                'Chuẩn bị sẵn túi cứu hộ (nước, thực phẩm khô, thuốc men).',
                'Ngắt nguồn điện trong nhà nếu nước bắt đầu dâng cao.',
              ],
            ),
            const SizedBox(height: 12),
            _buildSafetyGuideList(
              title: 'KHÔNG NÊN LÀM',
              color: const Color(0xFFDC2626),
              icon: Icons.cancel_outlined,
              items: [
                'Không lội qua dòng nước lũ đang chảy xiết.',
                'Không cố gắng lái xe qua các đoạn đường đã bị ngập.',
                'Không đánh bắt cá hoặc vớt củi trên sông khi có lũ.',
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0058BE), Color(0xFF2170E4)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(color: Color(0x140058BE), blurRadius: 32, offset: Offset(0, 12))
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              category,
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                time,
                style: GoogleFonts.manrope(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  source,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child, IconData? icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x19C2C6D6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: const Color(0xFF424754)),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF424754),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildAreaTag(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: GoogleFonts.manrope(
          color: const Color(0xFF0058BE),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSafetyGuideList({
    required String title,
    required Color color,
    required IconData icon,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: color.withOpacity(0.3), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF505F76),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
