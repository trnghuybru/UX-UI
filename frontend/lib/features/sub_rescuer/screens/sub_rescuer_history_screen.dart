import 'package:flutter/material.dart';

import '../sub_rescuer_constants.dart';
import 'sub_rescuer_report_screen.dart';

class _Mission {
  const _Mission({
    required this.id,
    required this.type,
    required this.tag,
    required this.when,
    required this.victim,
    required this.location,
    required this.rating,
  });

  final String id;
  final String type;
  final String tag;
  final String when;
  final String victim;
  final String location;
  final int rating;
}

class SubRescuerHistoryScreen extends StatelessWidget {
  const SubRescuerHistoryScreen({super.key});

  static const List<_Mission> _missions = [
    _Mission(
      id: kSubRescuerDemoSosId,
      type: 'Tai nạn giao thông',
      tag: 'KHẨN CẤP',
      when: '14:30, 24 Th05, 2024',
      victim: 'Nguyễn Văn Nam',
      location: 'Q.1, TP.HCM',
      rating: 5,
    ),
    _Mission(
      id: '7720',
      type: 'Cứu hộ leo núi',
      tag: 'HỖ TRỢ',
      when: '09:10, 22 Th05, 2024',
      victim: 'Trần Thị B',
      location: 'Lâm Đồng',
      rating: 4,
    ),
    _Mission(
      id: '6611',
      type: 'Cấp cứu y tế',
      tag: 'KHẨN CẤP',
      when: '18:45, 20 Th05, 2024',
      victim: 'Lê Văn C',
      location: 'Thủ Đức',
      rating: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ColoredBox(
      color: const Color(0xFFF0F4F8),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text(
              'Lịch sử cứu hộ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Theo dõi và xem lại các nhiệm vụ đã hoàn thành',
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo tên nạn nhân hoặc sự cố…',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
                        child: const Text('Ngày'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: () {},
                        style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
                        child: const Text('Loại hình'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ..._missions.map((m) {
              final emergency = m.tag == 'KHẨN CẤP';
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient(
                                  colors: [cs.outlineVariant.withValues(alpha: 0.35), cs.outlineVariant.withValues(alpha: 0.55)],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: emergency ? const Color(0xFFFEE2E2) : cs.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          m.tag,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: emergency ? const Color(0xFFB91C1C) : cs.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(m.when, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(m.type, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cs.onSurface)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i < m.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                                        color: Colors.amber.shade600,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('NẠN NHÂN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: cs.onSurfaceVariant)),
                                  Text(m.victim, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: cs.onSurface)),
                                  const SizedBox(height: 6),
                                  Text('VỊ TRÍ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: cs.onSurfaceVariant)),
                                  Text(m.location, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text('Xem lại báo cáo', style: TextStyle(fontWeight: FontWeight.w800, color: cs.primary)),
                        trailing: Icon(Icons.chevron_right_rounded, color: cs.primary),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => SubRescuerReportScreen(sosId: m.id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
