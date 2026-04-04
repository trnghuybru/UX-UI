import 'package:flutter/material.dart';
import '../models/shelter_request.dart';
import '../widgets/custom_app_bar.dart';
import 'shelter_management_screen.dart';

class ShelterRequestHistoryScreen extends StatefulWidget {
  const ShelterRequestHistoryScreen({super.key});

  @override
  State<ShelterRequestHistoryScreen> createState() => _ShelterRequestHistoryScreenState();
}

class _ShelterRequestHistoryScreenState extends State<ShelterRequestHistoryScreen> {
  final List<ShelterRequest> _mockRequests = [
    ShelterRequest(
      id: '1',
      name: 'Nhà văn hóa Hòa Hải',
      address: 'Số 123 đường Trường Sa, Hòa Hải, Ngũ Hành Sơn, Đà Nẵng',
      capacity: 100,
      currentOccupants: 45,
      status: ShelterRequestStatus.approved,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      amenities: ['Nước sạch', 'Thực phẩm', 'Y tế'],
    ),
    ShelterRequest(
      id: '2',
      name: 'Trường Tiểu học Lê Quý Đôn',
      address: 'Số 45 đường Nam Kỳ Khởi Nghĩa, Hòa Quý, Ngũ Hành Sơn, Đà Nẵng',
      capacity: 200,
      currentOccupants: 0,
      status: ShelterRequestStatus.pending,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      amenities: ['Nước sạch', 'Wifi'],
    ),
    ShelterRequest(
      id: '3',
      name: 'Chùa Quan Thế Âm',
      address: 'Sư Vạn Hạnh, Hòa Hải, Ngũ Hành Sơn, Đà Nẵng',
      capacity: 150,
      currentOccupants: 0,
      status: ShelterRequestStatus.rejected,
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      amenities: ['Nước sạch', 'Thực phẩm'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E14) : const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(title: 'Yêu cầu đăng ký trú ẩn'),
      body: _mockRequests.isEmpty
          ? _buildEmptyState(isDark)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: _mockRequests.length,
              itemBuilder: (context, index) {
                return _buildRequestCard(_mockRequests[index], isDark);
              },
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

  Widget _buildRequestCard(ShelterRequest request, bool isDark) {
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
          onTap: request.status == ShelterRequestStatus.approved
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShelterManagementScreen(request: request),
                    ),
                  );
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
                    if (request.status == ShelterRequestStatus.approved)
                      _buildInfoColumn(
                        'Hiện có',
                        '${request.currentOccupants} người',
                        isDark,
                        valueColor: request.currentOccupants >= request.capacity ? Colors.red : const Color(0xFF0058BE),
                      ),
                    _buildInfoColumn(
                      'Ngày gửi',
                      '${request.timestamp.day}/${request.timestamp.month}/${request.timestamp.year}',
                      isDark,
                    ),
                  ],
                ),
                if (request.status == ShelterRequestStatus.approved) ...[
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
                        style: TextStyle(
                          color: const Color(0xFF0058BE),
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

  Widget _buildStatusBadge(ShelterRequest request) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: request.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(request.statusIcon, size: 12, color: request.statusColor),
          const SizedBox(width: 4),
          Text(
            request.statusLabel,
            style: TextStyle(
              color: request.statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
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
