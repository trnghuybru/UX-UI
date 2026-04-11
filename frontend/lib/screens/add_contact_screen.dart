import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/contact_service.dart';
import '../services/user_session.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRelationship;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isPerformingRequest = false;
  bool _isPrimary = false;

  final List<String> _relationships = [
    'Bố',
    'Mẹ',
    'Vợ',
    'Chồng',
    'Anh/Chị/Em',
    'Con cái',
    'Bạn bè',
    'Đồng nghiệp',
    'Cơ quan',
    'Khác'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 120),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BACK BUTTON
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF7F9FB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Color(0xFF0058BE), size: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Trở về hồ sơ',
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF0058BE),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // HEADER
                    Text(
                      'Thêm liên hệ mới',
                      style: GoogleFonts.beVietnamPro(
                        color: const Color(0xFF191B24),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.75,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đảm bảo thông tin liên lạc chính xác để người hỗ trợ có thể liên hệ với người thân của bạn nhanh nhất.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF424656),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // FORM CARD
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A191B24),
                            blurRadius: 32,
                            offset: Offset(0, 12),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('HỌ VÀ TÊN'),
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Ví dụ: Nguyễn Văn A',
                            validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập họ tên' : null,
                          ),
                          const SizedBox(height: 24),

                          _buildFieldLabel('SỐ ĐIỆN THOẠI'),
                          _buildTextField(
                            controller: _phoneController,
                            hint: '09xx xxx xxx',
                            keyboardType: TextInputType.phone,
                            validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                          ),
                          const SizedBox(height: 24),

                          _buildFieldLabel('MỐI QUAN HỆ'),
                          _buildDropdownField(),
                          const SizedBox(height: 32),

                          // IS PRIMARY TOGGLE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Liên hệ chính',
                                    style: GoogleFonts.inter(color: const Color(0xFF191B24), fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Được ưu tiên gọi đầu tiên',
                                    style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isPrimary,
                                onChanged: (val) => setState(() => _isPrimary = val),
                                activeColor: const Color(0xFF0050CB),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // INFO BOX
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E7F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFF294487), size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Liên hệ khẩn cấp sẽ được hiển thị ngay cả khi điện thoại bị khóa để nhân viên y tế có thể hỗ trợ bạn nhanh nhất.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF294487),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM SAVE BUTTON
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF191B24).withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: _isPerformingRequest ? null : _submitForm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0050CB), Color(0xFF0066FF)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0050CB).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isPerformingRequest 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Text(
                            'Lưu liên hệ mới',
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFF424656),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(color: const Color(0xFF191B24), fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: const Color(0x7F424656), fontSize: 16),
        filled: true,
        fillColor: const Color(0xFFF2F3FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedRelationship,
          hint: Text(
            'Chọn mối quan hệ',
            style: GoogleFonts.inter(color: const Color(0x7F424656), fontSize: 16),
          ),
          decoration: const InputDecoration(border: InputBorder.none),
          items: _relationships.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.inter(color: const Color(0xFF191B24), fontSize: 16)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedRelationship = newValue;
            });
          },
          validator: (val) => val == null ? 'Vui lòng chọn mối quan hệ' : null,
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isPerformingRequest = true);

      try {
        final token = UserSession().accessToken;
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập lại')));
          return;
        }

        final success = await ContactService().addContact(
          name: _nameController.text,
          phone: _phoneController.text,
          relationship: _selectedRelationship!,
          isPrimary: _isPrimary,
          token: token,
        );

        if (success) {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Đã thêm liên hệ thành công!'), backgroundColor: Colors.green),
             );
             Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Có lỗi xảy ra khi lưu liên hệ'), backgroundColor: Colors.red),
             );
          }
        }
      } finally {
        if (mounted) setState(() => _isPerformingRequest = false);
      }
    }
  }
}
