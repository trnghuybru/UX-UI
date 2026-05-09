import 'package:flutter/material.dart';

import 'sub_rescuer_request_detail_screen.dart';
import '../../../services/sos_service.dart';
import '../../../services/user_session.dart';
import 'sub_rescuer_coordination_screen.dart';

enum _Priority { high, medium, low }

class SubRescuerRequestListScreen extends StatefulWidget {
  const SubRescuerRequestListScreen({super.key, this.onSwitchTab});

  final ValueChanged<int>? onSwitchTab;

  @override
  State<SubRescuerRequestListScreen> createState() => _SubRescuerRequestListScreenState();
}

class _SubRescuerRequestListScreenState extends State<SubRescuerRequestListScreen> {
  final SosService _sosService = SosService();
  List<SosRequestModel> _items = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final token = UserSession().accessToken;
    if (token == null || token.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Phiên đăng nhập đã hết hạn.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final rows = await _sosService.fetchEmergencySosRequests(token: token);
    if (!mounted) return;
    setState(() {
      _items = rows.where((x) {
        final s = x.status.toUpperCase();
        return s != 'COMPLETED' && s != 'FAILED' && s != 'CANCELLED';
      }).toList();
      _loading = false;
    });
  }

  Future<void> _acceptAndOpen(SosRequestModel item) async {
    final token = UserSession().accessToken;
    if (token == null || token.isEmpty) return;
    final ok = await _sosService.acceptSosRequest(sosId: item.id, token: token);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể nhận ca. Có thể ca đã được đội khác nhận.')),
      );
      await _load();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SubRescuerCoordinationScreen(sosId: item.id.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ColoredBox(
      color: const Color(0xFFF0F4F8),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách yêu cầu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: cs.onSurface),
                  ),
                ),
                IconButton.filledTonal(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
                IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryBox(
                          label: 'Đang chờ',
                          value: '${_items.where((x) => x.status.toUpperCase() == 'PENDING').length}',
                          bg: const Color(0xFFFEF2F2),
                          fg: const Color(0xFFB91C1C),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryBox(
                          label: 'Khẩn cấp cao',
                          value: '${_items.where((x) => x.peopleCount >= 3).length}',
                          bg: const Color(0xFFFFF7ED),
                          fg: const Color(0xFF9A3412),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(label: 'Lọc: < 5 km'),
                      _FilterChip(label: 'Phản hồi: < 4 phút'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(_error!, style: TextStyle(color: cs.error)),
              )
            else ..._items.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RequestCard(
                  item: r,
                  onOpen: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SubRescuerRequestDetailScreen(sosId: r.id.toString()),
                      ),
                    );
                  },
                  onAccept: () => _acceptAndOpen(r),
                  onResume: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SubRescuerCoordinationScreen(sosId: r.id.toString()),
                      ),
                    );
                  },
                ),
              )),
            TextButton(
              onPressed: () => widget.onSwitchTab?.call(0),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  const _SummaryBox({
    required this.label,
    required this.value,
    required this.bg,
    required this.fg,
  });

  final String label;
  final String value;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: fg),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.item,
    required this.onOpen,
    required this.onAccept,
    required this.onResume,
  });

  final SosRequestModel item;
  final VoidCallback onOpen;
  final VoidCallback onAccept;
  final VoidCallback onResume;

  Color _border(_Priority p) {
    switch (p) {
      case _Priority.high:
        return const Color(0xFFF87171);
      case _Priority.medium:
        return const Color(0xFFFBBF24);
      case _Priority.low:
        return const Color(0xFF0058BE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isInProgress = item.status.toUpperCase() == 'IN_PROGRESS';
    final variant = isInProgress
        ? _Priority.low
        : (item.peopleCount >= 3 ? _Priority.high : _Priority.medium);
    final b = _border(variant);

    return Material(
      color: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: b, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [cs.outlineVariant.withValues(alpha: 0.35), cs.outlineVariant.withValues(alpha: 0.6)],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.type ?? 'Yêu cầu cứu hộ',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface, height: 1.25),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description?.trim().isNotEmpty == true ? item.description!.trim() : 'Chưa có mô tả',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ca #${item.id} · ${item.status}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: isInProgress ? onResume : onAccept,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isInProgress ? 'Quay trở lại' : 'Nhận ca ngay'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: onOpen,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Xem chi tiết'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
