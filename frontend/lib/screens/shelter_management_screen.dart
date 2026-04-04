import 'package:flutter/material.dart';
import '../models/shelter_request.dart';
import '../widgets/custom_app_bar.dart';

class ShelterManagementScreen extends StatefulWidget {
  final ShelterRequest request;
  const ShelterManagementScreen({super.key, required this.request});

  @override
  State<ShelterManagementScreen> createState() => _ShelterManagementScreenState();
}

class _ShelterManagementScreenState extends State<ShelterManagementScreen> {
  int _currentOccupants = 0;
  late TextEditingController _controller;
  bool _hasWater = false;
  bool _hasFood = false;
  bool _hasMedical = false;
  bool _hasElectricity = false;
  bool _hasWifi = false;

  @override
  void initState() {
    super.initState();
    _currentOccupants = widget.request.currentOccupants;
    _controller = TextEditingController(text: _currentOccupants.toString());
    
    // Initialize amenities based on existing list
    _hasWater = widget.request.amenities.contains('Nước sạch');
    _hasFood = widget.request.amenities.contains('Thực phẩm');
    _hasMedical = widget.request.amenities.contains('Y tế');
    _hasElectricity = widget.request.amenities.contains('Điện');
    _hasWifi = widget.request.amenities.contains('Wifi');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateOccupants(int delta) {
    setState(() {
      _currentOccupants = (_currentOccupants + delta).clamp(0, widget.request.capacity);
      _controller.text = _currentOccupants.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = const Color(0xFF0058BE);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: 'Quản lý: ${widget.request.name}'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatusCard(isDark, accentColor),
                  const SizedBox(height: 24),
                  _buildManagementCard(isDark, accentColor),
                  const SizedBox(height: 24),
                  _buildAmenitiesSection(isDark, accentColor),
                  const SizedBox(height: 24),
                  _buildInfoCard(isDark),
                  const SizedBox(height: 48),
                  _buildSaveButton(accentColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatusCard(bool isDark, Color accentColor) {
    double progress = _currentOccupants / widget.request.capacity;
    Color progressColor = progress >= 0.9 ? Colors.red : (progress >= 0.7 ? Colors.orange : accentColor);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D2024) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: !isDark ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tỷ lệ lấp đầy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
              color: progressColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_currentOccupants',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: progressColor,
                ),
              ),
              Text(
                ' / ${widget.request.capacity}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'NGƯỜI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard(bool isDark, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D2024) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: !isDark ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CẬP NHẬT SỐ NGƯỜI HIỆN CÓ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Color(0xFF0058BE),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAdjustButton(Icons.remove, () => _updateOccupants(-1), isDark),
              const SizedBox(width: 32),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (val) {
                    final int? n = int.tryParse(val);
                    if (n != null) {
                      setState(() {
                        _currentOccupants = n.clamp(0, widget.request.capacity);
                      });
                    }
                  },
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF191C1E),
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(width: 32),
              _buildAdjustButton(Icons.add, () => _updateOccupants(1), isDark),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildQuickAdjustButton('+5', () => _updateOccupants(5), isDark),
              const SizedBox(width: 12),
              _buildQuickAdjustButton('+10', () => _updateOccupants(10), isDark),
              const SizedBox(width: 12),
              _buildQuickAdjustButton('Hết chỗ', () => setState(() {
                _currentOccupants = widget.request.capacity;
                _controller.text = _currentOccupants.toString();
              }), isDark, isWarning: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustButton(IconData icon, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: isDark ? Colors.white : const Color(0xFF0058BE)),
      ),
    );
  }

  Widget _buildQuickAdjustButton(String label, VoidCallback onTap, bool isDark, {bool isWarning = false}) {
    Color color = isWarning ? Colors.red : (isDark ? Colors.white24 : Colors.grey.shade100);
    Color textColor = isWarning ? Colors.white : (isDark ? Colors.white : const Color(0xFF191C1E));

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D2024).withOpacity(0.5) : const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.location_on_outlined, 'Địa chỉ', widget.request.address, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.white38 : Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white38 : Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : const Color(0xFF191C1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(bool isDark, Color accentColor) {
    final Color textColor = isDark ? const Color(0xFFF1F3FC) : const Color(0xFF191C1E);
    final Color cardColor = isDark ? const Color(0xFF1D2024) : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: !isDark ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TIỆN NGHI CÓ SẴN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Color(0xFF0058BE),
            ),
          ),
          const SizedBox(height: 20),
          _buildAmenitySwitch(
            label: 'Nước sạch',
            icon: Icons.water_drop_rounded,
            value: _hasWater,
            onChanged: (v) => setState(() => _hasWater = v),
            accentColor: accentColor,
            textColor: textColor,
          ),
          _buildAmenitySwitch(
            label: 'Thực phẩm',
            icon: Icons.restaurant_rounded,
            value: _hasFood,
            onChanged: (v) => setState(() => _hasFood = v),
            accentColor: accentColor,
            textColor: textColor,
          ),
          _buildAmenitySwitch(
            label: 'Y tế cơ cứu',
            icon: Icons.medical_services_rounded,
            value: _hasMedical,
            onChanged: (v) => setState(() => _hasMedical = v),
            accentColor: accentColor,
            textColor: textColor,
          ),
          _buildAmenitySwitch(
            label: 'Nguồn điện',
            icon: Icons.electrical_services_rounded,
            value: _hasElectricity,
            onChanged: (v) => setState(() => _hasElectricity = v),
            accentColor: accentColor,
            textColor: textColor,
          ),
          _buildAmenitySwitch(
            label: 'Wifi',
            icon: Icons.wifi_rounded,
            value: _hasWifi,
            onChanged: (v) => setState(() => _hasWifi = v),
            accentColor: accentColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitySwitch({
    required String label,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required Color accentColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(Color accentColor) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // In a real app, this would call an API
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thành công!')),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'Lưu thay đổi',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
