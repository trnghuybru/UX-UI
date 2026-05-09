import 'package:flutter/material.dart';

import '../sub_rescuer_shell.dart';
import 'sub_rescuer_navigation_screen.dart';

class SubRescuerCoordinationScreen extends StatefulWidget {
  const SubRescuerCoordinationScreen({super.key, required this.sosId});

  final String sosId;

  @override
  State<SubRescuerCoordinationScreen> createState() => _SubRescuerCoordinationScreenState();
}

class _SubRescuerCoordinationScreenState extends State<SubRescuerCoordinationScreen> {
  int _minutes = 15;
  final Map<String, bool> _gear = {'first_aid': true, 'aed': false, 'flashlight': true};

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Sóng Cứu Hộ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
                  IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded, color: cs.primary, size: 40),
              ),
              const SizedBox(height: 12),
              Text(
                'Đã tiếp nhận yêu cầu',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: cs.onSurface),
              ),
              const SizedBox(height: 16),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Khẩn cấp',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFB91C1C)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('#${widget.sosId}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Tai nạn xe máy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: cs.onSurface)),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_rounded, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '123 Đường Lê Lợi, Quận 1, TP.HCM',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _InfoTile(label: 'Nạn nhân', value: 'Nguyễn Văn A')),
                        const SizedBox(width: 12),
                        Expanded(child: _InfoTile(label: 'Tình trạng', value: 'Chấn thương chân')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời gian dự kiến đến hiện trường',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => setState(() => _minutes = (_minutes - 1).clamp(1, 120)),
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$_minutes phút',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: cs.onSurface),
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => setState(() => _minutes = (_minutes + 1).clamp(1, 120)),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [5, 15, 30].map((m) {
                        final sel = _minutes == m;
                        return ChoiceChip(
                          label: Text('$m phút'),
                          selected: sel,
                          onSelected: (_) => setState(() => _minutes = m),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thiết bị mang theo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                    const SizedBox(height: 12),
                    _GearTile(
                      label: 'Túi sơ cứu y tế',
                      value: _gear['first_aid']!,
                      onChanged: (v) => setState(() => _gear['first_aid'] = v),
                    ),
                    _GearTile(
                      label: 'Máy kích tim ngoài (AED)',
                      value: _gear['aed']!,
                      onChanged: (v) => setState(() => _gear['aed'] = v),
                    ),
                    _GearTile(
                      label: 'Đèn pin cường độ cao',
                      value: _gear['flashlight']!,
                      onChanged: (v) => setState(() => _gear['flashlight'] = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SubRescuerNavigationScreen(sosId: widget.sosId),
                    ),
                  );
                },
                icon: const Icon(Icons.navigation_rounded),
                label: const Text('Bắt đầu di chuyển'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: 1,
        indicatorColor: cs.primary.withValues(alpha: 0.12),
        onDestinationSelected: (i) {
          if (i == 1) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => SubRescuerShellScreen(initialIndex: i),
            ),
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Yêu cầu',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Lịch sử',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: cs.onSurface)),
        ],
      ),
    );
  }
}

class _GearTile extends StatelessWidget {
  const _GearTile({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        child: CheckboxListTile(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          controlAffinity: ListTileControlAffinity.leading,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
