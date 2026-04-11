import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';

class OfflineSosScreen extends StatefulWidget {
  const OfflineSosScreen({super.key});

  @override
  State<OfflineSosScreen> createState() => _OfflineSosScreenState();
}

class _OfflineSosScreenState extends State<OfflineSosScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isLocating = true;
  ({double lat, double lon})? _currentLocation;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _peopleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    setState(() => _isLocating = true);
    final pos = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        _currentLocation = pos;
        _isLocating = false;
      });
    }
  }

  Future<void> _sendSmsSos() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại.')),
      );
      return;
    }

    final sosData = {
      'phone': _phoneController.text,
      'people_count': int.tryParse(_peopleController.text) ?? 1,
      'lat': _currentLocation?.lat,
      'lng': _currentLocation?.lon,
      'description': _descController.text,
    };

    final jsonString = json.encode(sosData);
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: '0972087664',
      queryParameters: <String, String>{
        'body': jsonString,
      },
    );

    try {
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        await launchUrl(smsLaunchUri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể mở ứng dụng tin nhắn: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        title: const Text('GỬI SOS KHẨN CẤP'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, color: Colors.red),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Chế độ ngoại tuyến: SOS sẽ được gửi qua tin nhắn SMS tới trung tâm cứu hộ.',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildLocationStatus(isDark),
            const SizedBox(height: 24),
            _buildTextFieldLabel('SỐ ĐIỆN THOẠI LIÊN HỆ', isDark),
            const SizedBox(height: 8),
            _buildTextField('Nhập số điện thoại...', isDark, controller: _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextFieldLabel('SỐ NGƯỜI CẦN CỨU', isDark),
            const SizedBox(height: 8),
            _buildTextField('Nhập số lượng người...', isDark, controller: _peopleController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextFieldLabel('MÔ TẢ TÌNH HUỐNG', isDark),
            const SizedBox(height: 8),
            _buildTextField('Nhập tình trạng hiện tại...', isDark, controller: _descController, maxLines: 4),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _sendSmsSos,
                icon: const Icon(Icons.send),
                label: const Text('GỬI SOS QUA SMS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Lưu ý: Bạn phải chịu trách nhiệm về thông tin báo khẩn cấp này.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStatus(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tọa độ GPS:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (_isLocating)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              else
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _currentLocation != null 
                ? '${_currentLocation!.lat.toStringAsFixed(6)}, ${_currentLocation!.lon.toStringAsFixed(6)}'
                : (_isLocating ? 'Đang xác định vị trí...' : 'Không thể lấy vị trí'),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String text, bool isDark) {
    return Text(text, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12, fontWeight: FontWeight.bold));
  }

  Widget _buildTextField(String hint, bool isDark, {required TextEditingController controller, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
