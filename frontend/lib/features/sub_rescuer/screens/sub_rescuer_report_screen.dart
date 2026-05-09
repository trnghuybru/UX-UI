import 'package:flutter/material.dart';

class SubRescuerReportScreen extends StatefulWidget {
  const SubRescuerReportScreen({super.key, required this.sosId});

  final String sosId;

  @override
  State<SubRescuerReportScreen> createState() => _SubRescuerReportScreenState();
}

class _SubRescuerReportScreenState extends State<SubRescuerReportScreen> {
  String _status = 'safe';
  final TextEditingController _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: const Text('Hoàn thành ca cứu hộ', style: TextStyle(fontWeight: FontWeight.w800)),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hình ảnh hiện trường', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Thêm ảnh'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(96),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(colors: [Colors.blueGrey.shade200, Colors.blueGrey.shade400]),
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
                  Text('Tình trạng nạn nhân', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'safe', child: Text('An toàn / Đã sơ cứu')),
                      DropdownMenuItem(value: 'evac', child: Text('Đã sơ tán')),
                      DropdownMenuItem(value: 'hospital', child: Text('Chuyển viện')),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? _status),
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
                  Text('Ghi chú kết quả', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notes,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Mô tả ngắn gọn diễn biến và biện pháp đã thực hiện…',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Hoàn thành ca cứu hộ'),
          ),
        ],
      ),
    );
  }
}
