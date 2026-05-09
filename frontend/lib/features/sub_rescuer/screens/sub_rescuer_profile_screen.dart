import 'package:flutter/material.dart';

import '../../../screens/login_screen.dart';
import '../../../services/user_session.dart';

class SubRescuerProfileScreen extends StatefulWidget {
  const SubRescuerProfileScreen({super.key});

  @override
  State<SubRescuerProfileScreen> createState() => _SubRescuerProfileScreenState();
}

class _SubRescuerProfileScreenState extends State<SubRescuerProfileScreen> {
  bool _active = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = UserSession().currentUser;
    final name = user?.fullName ?? 'Nguyễn Minh Tuấn';

    return ColoredBox(
      color: const Color(0xFFF0F4F8),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Text('Hồ sơ người cứu hộ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: cs.onSurface)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade500]),
                      boxShadow: [BoxShadow(color: cs.primary.withValues(alpha: 0.2), blurRadius: 0, spreadRadius: 4)],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 4),
                  Text(
                    'RS-20948 · Đội trưởng cứu hộ',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '4,9 ★ (128 phản hồi)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.amber.shade800),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Chỉnh sửa hồ sơ'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trạng thái hoạt động', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                        const SizedBox(height: 4),
                        Text(
                          _active ? 'Đang sẵn sàng nhận ca' : 'Tạm nghỉ',
                          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(value: _active, onChanged: (v) => setState(() => _active = v)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Kỹ năng',
              child: Column(
                children: [
                  _SkillBar(label: 'Sơ cấp cứu nâng cao', pct: 0.95),
                  _SkillBar(label: 'Cứu hộ vùng nước dữ', pct: 0.80),
                  _SkillBar(label: 'Leo núi & Đu dây', pct: 0.88),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(label: 'Lái xe cứu thương'),
                      _Tag(label: 'Phòng cháy chữa cháy'),
                      _Tag(label: 'Ứng cứu điện'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0058BE), Color(0xFF2170E4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0058BE).withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ca cứu hộ thành công', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9))),
                  Text('42', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('+12% so với tháng trước', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.green.shade200)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Thiết bị hiện có',
              child: Column(
                children: ['Túi sơ cứu', 'Bộ đàm', 'Đèn pin']
                    .map(
                      (x) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check_circle_rounded, color: cs.primary),
                        title: Text(x, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Hoạt động gần đây',
              child: Column(
                children: [
                  _ActivityRow(title: 'Tai nạn giao thông', status: 'Hoàn thành'),
                  const Divider(),
                  _ActivityRow(title: 'Cấp cứu y tế', status: 'Hoàn thành'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                UserSession().clearSession();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.error,
                side: BorderSide(color: cs.error.withValues(alpha: 0.5)),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cs.onSurface)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.label, required this.pct});

  final String label;
  final double pct;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
              Text('${(pct * 100).round()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: cs.primary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: const Color(0xFFF1F5F9), color: cs.primary),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: cs.primary)),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.title, required this.status});

  final String title;
  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface))),
          Text(status, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF059669))),
        ],
      ),
    );
  }
}
