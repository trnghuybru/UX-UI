import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            _buildContactsGrid(),
            const SizedBox(height: 24),
            _buildLocationCard(),
            const SizedBox(height: 24),
            _buildFormSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: const Color(0xFFDC2C4F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26B90538),
            blurRadius: 32,
            offset: Offset(0, 12),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(Icons.sos, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GỬI LỜI CẦU CỨU',
                  style: TextStyle(
                    color: Color(0xFFFFFBFF),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.33,
                    letterSpacing: -0.60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chức năng khẩn cấp - Sử dụng khi gặp nguy hiểm',
                  style: TextStyle(
                    color: const Color(0xFFFFFBFF).withValues(alpha: 0.90),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildContactItem('CẢNH SÁT', '113', const Color(0xFFDBEAFE), const Color(0xFF0058BE), width, Icons.local_police),
            _buildContactItem('CỨU HỎA', '114', const Color(0xFFFEE2E2), const Color(0xFFB90538), width, Icons.local_fire_department),
            _buildContactItem('CẤP CỨU', '115', const Color(0xFFD1FAE5), const Color(0xFF059669), width, Icons.medical_services),
            _buildContactItem('SOS', '112', const Color(0xFFFFEDD5), const Color(0xFFEA580C), width, Icons.support),
          ],
        );
      },
    );
  }

  Widget _buildContactItem(String title, String number, Color bgColor, Color fgColor, double width, IconData icon) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Icon(icon, color: fgColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          Text(
            number,
            style: TextStyle(color: fgColor, fontSize: 20, fontWeight: FontWeight.w800, height: 1.40),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Vị trí của bạn', style: TextStyle(color: Color(0xFF424754), fontSize: 14, fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0x190058BE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                ),
                child: const Text('ĐANG CẬP NHẬT', style: TextStyle(color: Color(0xFF0058BE), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x4CC2C6D6)),
              image: const DecorationImage(
                image: NetworkImage("https://placehold.co/600x400/png?text=Map"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                    child: const Text('16.0544° N, 108.2022° E', style: TextStyle(color: Color(0xFF0058BE), fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                    child: const Text('Phường 22, Quận Bình Thạnh, TP.HCM', style: TextStyle(color: Color(0xFF1E293B), fontSize: 10, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldLabel('SỐ NGƯỜI CẦN CỨU', required: true),
        const SizedBox(height: 8),
        _buildTextField('Nhập số lượng người...'),
        const SizedBox(height: 16),
        _buildTextFieldLabel('MÔ TẢ TÌNH HUỐNG (KHÔNG BẮT BUỘC)', required: false),
        const SizedBox(height: 8),
        _buildTextField('Nhập chi tiết về tình trạng khẩn cấp hiện tại của bạn...', maxLines: 4),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Color(0xFFC2C6D6)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Text('Đính kèm ảnh/video', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: ShapeDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFB90538), Color(0xFFDC2C4F)]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            shadows: const [BoxShadow(color: Color(0x3FB90538), blurRadius: 32, offset: Offset(0, 12))],
          ),
          child: const Text(
            'GỬI CẦU CỨU NGAY',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Lưu ý: Bạn phải hoàn toàn chịu trách nhiệm về thông tin cung cấp. Việc báo tin giả có thể bị truy cứu trách nhiệm.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldLabel(String text, {bool required = false}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w700)),
          if (required) const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFBA1A1A), fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFFF2F4F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
