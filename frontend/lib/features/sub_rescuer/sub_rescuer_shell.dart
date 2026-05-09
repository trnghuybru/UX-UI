import 'package:flutter/material.dart';

import 'screens/sub_rescuer_dashboard_screen.dart';
import 'screens/sub_rescuer_history_screen.dart';
import 'screens/sub_rescuer_profile_screen.dart';
import 'screens/sub_rescuer_request_list_screen.dart';

/// Cổng dành cho tài khoản role RESCUER — bottom nav tách biệt khỏi [ShellScreen] người dùng thường.
class SubRescuerShellScreen extends StatefulWidget {
  const SubRescuerShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<SubRescuerShellScreen> createState() => _SubRescuerShellScreenState();
}

class _SubRescuerShellScreenState extends State<SubRescuerShellScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          SubRescuerDashboardScreen(onSwitchTab: (i) => setState(() => _index = i)),
          SubRescuerRequestListScreen(
            onSwitchTab: (i) => setState(() => _index = i),
          ),
          const SubRescuerHistoryScreen(),
          const SubRescuerProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: _index,
        indicatorColor: primary.withValues(alpha: 0.12),
        onDestinationSelected: (i) => setState(() => _index = i),
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
