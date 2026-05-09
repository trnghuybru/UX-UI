import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SubRescuerChatScreen extends StatefulWidget {
  const SubRescuerChatScreen({super.key, required this.sosId});

  final String sosId;

  @override
  State<SubRescuerChatScreen> createState() => _SubRescuerChatScreenState();
}

class _SubRescuerChatScreenState extends State<SubRescuerChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EDF2),
      appBar: AppBar(
        backgroundColor: cs.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lê Thị Thanh', style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface, fontSize: 16)),
            Text(
              'Đang khẩn cấp · #${widget.sosId}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.error),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: () => launchUrl(Uri.parse('tel:0901234567')),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text('Gọi ngay', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _Bubble(
                  alignLeft: true,
                  child: const Text('Anh ơi em bị kẹt ở góc cầu, khói nhiều quá…'),
                ),
                _Bubble(
                  alignLeft: false,
                  child: const Text('Đội đang tới, giữ bình tĩnh và tránh vùng khói nhé.'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.72,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(18).copyWith(bottomLeft: const Radius.circular(6)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.red.shade600]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('Ảnh từ hiện trường', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: cs.surface,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _QuickChip(
                          label: 'Tôi đang trên đường đến',
                          onTap: () => setState(() => _controller.text = 'Tôi đang trên đường đến'),
                        ),
                        _QuickChip(
                          label: 'Hãy giữ bình tĩnh',
                          onTap: () => setState(() => _controller.text = 'Hãy giữ bình tĩnh'),
                        ),
                        _QuickChip(
                          label: 'Đã gọi hỗ trợ thêm',
                          onTap: () => setState(() => _controller.text = 'Đã gọi hỗ trợ thêm'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file_rounded)),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Nhập tin nhắn…',
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.mic_none_rounded)),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(14)),
                        child: const Icon(Icons.send_rounded, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.alignLeft, required this.child});

  final bool alignLeft;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = alignLeft ? cs.surface : cs.primary;
    final fg = alignLeft ? cs.onSurface : cs.onPrimary;

    return Align(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomLeft: alignLeft ? const Radius.circular(6) : null,
            bottomRight: alignLeft ? null : const Radius.circular(6),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(fontSize: 14, height: 1.4, color: fg, fontWeight: FontWeight.w500),
          child: child,
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        onPressed: onTap,
      ),
    );
  }
}
