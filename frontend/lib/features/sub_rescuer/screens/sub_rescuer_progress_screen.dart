import 'package:flutter/material.dart';

import 'sub_rescuer_chat_screen.dart';
import 'sub_rescuer_report_screen.dart';

class SubRescuerProgressScreen extends StatelessWidget {
  const SubRescuerProgressScreen({super.key, required this.sosId});

  final String sosId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: const Text('Tiến độ cứu hộ', style: TextStyle(fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Container(
              height: 140,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFCFFAFE), Color(0xFFBFDBFE)]),
              ),
              child: Text(
                'Vị trí: Quận 1, TP.HCM',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.blue.shade900),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _StepRow(
                    title: 'Đang di chuyển',
                    time: '14:20',
                    isDone: true,
                    isCurrent: false,
                    trailing: null,
                  ),
                  _StepRow(
                    title: 'Đã đến hiện trường',
                    time: '',
                    isDone: false,
                    isCurrent: true,
                    trailing: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Xác nhận đã đến'),
                    ),
                  ),
                  _StepRow(
                    title: 'Đang xử lý',
                    time: '',
                    isDone: false,
                    isCurrent: false,
                    trailing: FilledButton(
                      onPressed: null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Bắt đầu xử lý'),
                    ),
                  ),
                  _StepRow(
                    title: 'Hoàn thành',
                    time: '',
                    isDone: false,
                    isCurrent: false,
                    trailing: null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thông tin nạn nhân', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 8),
                  Text('Nguyễn Văn A', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 4),
                  Text('Khẩn cấp', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: cs.error)),
                  const SizedBox(height: 8),
                  Text('0901 234 567', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13, height: 1.4, color: Colors.amber.shade900),
                        children: const [
                          TextSpan(text: 'Ghi chú điều phối: ', style: TextStyle(fontWeight: FontWeight.w800)),
                          TextSpan(
                            text: 'Mắc kẹt tại tầng lửng, có khói nhẹ, cần mặt nạ chống độc.',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Gọi hỗ trợ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB90538),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Báo động đỏ'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => SubRescuerChatScreen(sosId: sosId)),
                  );
                },
                child: const Text('Chat với nạn nhân'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => SubRescuerReportScreen(sosId: sosId)),
                  );
                },
                child: const Text('Báo cáo kết quả'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.title,
    required this.time,
    required this.isDone,
    required this.isCurrent,
    required this.trailing,
  });

  final String title;
  final String time;
  final bool isDone;
  final bool isCurrent;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primary = cs.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? primary : Colors.white,
                  border: Border.all(color: isCurrent ? primary : cs.outlineVariant, width: 2),
                ),
                child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isCurrent ? primary : cs.onSurface,
                        ),
                      ),
                    ),
                    if (time.isNotEmpty)
                      Text(time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant)),
                  ],
                ),
                if (trailing != null) ...[const SizedBox(height: 10), trailing!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
