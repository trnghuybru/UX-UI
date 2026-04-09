import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'shelter_management_screen.dart';
import '../models/shelter_model.dart';
import '../services/shelter_service.dart';
import '../services/user_session.dart';
import '../services/socket_service.dart';
import 'package:intl/intl.dart';

class ShelterRequestHistoryScreen extends StatefulWidget {
  const ShelterRequestHistoryScreen({super.key});

  @override
  State<ShelterRequestHistoryScreen> createState() => _ShelterRequestHistoryScreenState();
}

class _ShelterRequestHistoryScreenState extends State<ShelterRequestHistoryScreen> {
  List<ShelterModel> _myShelters = [];
  bool _isLoading = false;
  final ShelterService _shelterService = ShelterService();

  @override
  void initState() {
    super.initState();
    _fetchMyHistory();
    
    // Listen for real-time approval updates
    SocketService().initSocket(onShelterUpdate: (data) {
      if (mounted) _fetchMyHistory();
    });
  }

  @override
  void dispose() {
    // Note: In a singleton SocketService, you might not want to disconnect entirely
    // but just off the listener. Or leave it to the next screen.
    // However, our refactored SocketService disconnect() clears the callback.
    super.dispose();
  }

  Future<void> _fetchMyHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _shelterService.fetchMyShelters();
      if (mounted) {
        setState(() {
          _myShelters = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E14) : const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(title: 'Yêu cầu đăng ký trú ẩn'),
      body: RefreshIndicator(
        onRefresh: _fetchMyHistory,
        child: _isLoading && _myShelters.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _myShelters.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _buildEmptyState(isDark),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    itemCount: _myShelters.length,
                    itemBuilder: (context, index) {
                      return _buildRequestCard(_myShelters[index], isDark);
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_edu_rounded,
            size: 80,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có yêu cầu nào',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(ShelterModel request, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D2024) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: request.status == 'APPROVED'
              ? () {
                  // Since ShelterManagementScreen expects ShelterRequest, we map it or update it.
                  // For now, let's just navigate with a placeholder or handle it.
                  _navigateToManagement(request);
                }
              : null,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF191C1E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusBadge(request),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: isDark ? Colors.white60 : Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        request.address,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(
                      'Sức chứa',
                      '${request.capacity} người',
                      isDark,
                    ),
                    if (request.status == 'APPROVED')
                      _buildInfoColumn(
                        'Hiện có',
                        '${request.currentPeople} người',
                        isDark,
                        valueColor: request.currentPeople >= request.capacity ? Colors.red : const Color(0xFF0058BE),
                      ),
                    _buildInfoColumn(
                      'Ngày gửi',
                      DateFormat('dd/MM/yyyy').format(request.createdAt),
                      isDark,
                    ),
                  ],
                ),
                if (request.status == 'APPROVED') ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0058BE).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Quản lý địa điểm',
                        style: const TextStyle(
                          color: Color(0xFF0058BE),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ShelterModel request) {
    Color color = Colors.grey;
    String label = request.status;
    IconData icon = Icons.help_outline;

    switch (request.status) {
      case 'APPROVED':
        color = Colors.green;
        label = 'Đã phê duyệt';
        icon = Icons.check_circle_outline;
        break;
      case 'PENDING':
        color = Colors.orange;
        label = 'Đang chờ duyệt';
        icon = Icons.hourglass_empty;
        break;
      case 'REJECTED':
        color = Colors.red;
        label = 'Từ chối';
        icon = Icons.error_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToManagement(ShelterModel shelter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShelterManagementScreen(shelter: shelter),
      ),
    ).then((updated) {
      if (updated == true) {
        _fetchMyHistory();
      }
    });
  }

  Widget _buildInfoColumn(String label, String value, bool isDark, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white38 : Colors.grey.shade500,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? Colors.white : const Color(0xFF191C1E)),
          ),
        ),
      ],
    );
  }
}
