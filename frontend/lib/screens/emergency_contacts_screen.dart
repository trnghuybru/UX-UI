import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_contact_screen.dart';
import '../services/contact_service.dart';
import '../services/user_session.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<ContactModel> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final token = UserSession().accessToken;
    if (token == null) return;

    setState(() => _isLoading = true);
    final results = await ContactService().fetchContacts(token);
    if (mounted) {
      setState(() {
        _contacts = results;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteContact(int id) async {
    final token = UserSession().accessToken;
    if (token == null) return;

    final success = await ContactService().deleteContact(id, token);
    if (success) {
      _loadContacts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa liên hệ')));
      }
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadContacts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  'Danh bạ khẩn cấp',
                  style: GoogleFonts.beVietnamPro(
                    color: const Color(0xFF191B24),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    letterSpacing: -0.75,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Truy cập nhanh vào những người đáng tin\ncậy nhất trong trường hợp khẩn cấp.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF424656),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),

                // CATEGORY: CÁ NHÂN (DYNAMIC)
                _buildCategoryHeader('CÁ NHÂN', const Color(0xFF0050CB)),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_contacts.isEmpty)
                  _buildEmptyState()
                else
                  ..._contacts.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildContactCard(
                          id: c.id,
                          name: c.name,
                          relation: c.relationship,
                          phone: c.phone,
                          isPrimary: c.isPrimary,
                          canDelete: true,
                        ),
                      )),
                
                const SizedBox(height: 32),

                // CATEGORY: CƠ QUAN & TỔ CHỨC (STATIC)
                _buildCategoryHeader('CƠ QUAN & TỔ CHỨC', const Color(0xFF425CA0)),
                const SizedBox(height: 16),
                _buildContactCard(
                  name: 'Bệnh viện Vinmec',
                  relation: 'Cơ sở y tế • Hotline 24/7',
                  icon: Icons.local_hospital,
                  iconColor: const Color(0xFF0050CB),
                  phone: '1900232389',
                  isEmergency: true,
                  isOrg: true,
                ),
                const SizedBox(height: 12),
                _buildContactCard(
                  name: 'Cấp cứu TP. Đà Nẵng',
                  relation: 'Cấp cứu • Hotline 115',
                  icon: Icons.medical_services,
                  iconColor: const Color(0xFFDE211C),
                  phone: '115',
                  isEmergency: true,
                  isOrg: true,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactScreen()),
          );
          if (result == true) {
            _loadContacts();
          }
        },
        child: Container(
          width: 64,
          height: 64,
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
          child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(Icons.contact_phone_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Chưa có liên hệ cá nhân nào',
            style: GoogleFonts.manrope(color: Colors.grey[600], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    int? id,
    required String name,
    required String relation,
    String? imageUrl,
    IconData? icon,
    Color? iconColor,
    required String phone,
    bool isActive = false,
    bool isEmergency = false,
    bool isOrg = false,
    bool isPrimary = false,
    bool canDelete = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOrg && isEmergency ? const Color(0xFFF2F3FF) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isOrg && isEmergency ? Border.all(color: const Color(0xFF0050CB), width: 2) : (isPrimary ? Border.all(color: const Color(0xFF0050CB).withOpacity(0.3), width: 1) : null),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191B24).withOpacity(0.05),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          // AVATAR / ICON
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: icon != null ? (iconColor?.withOpacity(0.1) ?? Colors.grey[200]) : const Color(0xFFF1F5F9),
                  image: imageUrl != null
                      ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: icon != null ? Icon(icon, color: iconColor, size: 28) : (imageUrl == null ? const Icon(Icons.person, color: Color(0xFF64748B), size: 28) : null),
              ),
              if (isActive || isPrimary)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isPrimary ? const Color(0xFF0050CB) : const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: isPrimary ? const Icon(Icons.star, color: Colors.white, size: 8) : null,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF191B24),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isPrimary) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0050CB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'CHÍNH',
                          style: GoogleFonts.inter(color: const Color(0xFF0050CB), fontSize: 9, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  relation,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF424656),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ACTIONS (CALL / DELETE)
          if (canDelete && id != null)
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'delete') _deleteContact(id);
              },
              icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Xóa liên hệ', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          
          GestureDetector(
            onTap: () => _makeCall(phone),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isEmergency ? const Color(0xFFDE211C) : const Color(0xFF0050CB),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isEmergency ? const Color(0xFFDE211C) : const Color(0xFF0050CB)).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.call, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
