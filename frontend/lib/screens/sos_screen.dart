import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../services/location_service.dart';
import '../services/geocoding_service.dart';
import '../services/sos_service.dart';
import '../services/user_session.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  LatLng? _currentLocation;
  String _currentAddress = 'Đang xác định vị trí...';
  bool _isLocating = true;
  MapLibreMapController? _mapController;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = UserSession().currentUser?.phone ?? '';
    _initLocation();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _peopleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitSos() async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chờ xác định vị trí của bạn.')),
      );
      return;
    }

    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại liên hệ.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await SosService().createSos(
        phone: _phoneController.text,
        lat: _currentLocation!.latitude,
        lng: _currentLocation!.longitude,
        peopleCount: int.tryParse(_peopleController.text),
        description: _descController.text,
        token: UserSession().accessToken,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gửi yêu cầu cứu hộ thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gửi yêu cầu thất bại. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _sendSmsSos() async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chờ xác định vị trí của bạn.')),
      );
      return;
    }

    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại liên hệ.')),
      );
      return;
    }

    final sosData = {
      'phone': _phoneController.text,
      'people_count': int.tryParse(_peopleController.text) ?? 1,
      'lat': _currentLocation!.latitude,
      'lng': _currentLocation!.longitude,
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

  Future<void> _initLocation() async {
    setState(() => _isLocating = true);
    
    final pos = await LocationService.getCurrentLocation();
    if (mounted) {
      if (pos != null) {
        final latlng = LatLng(pos.lat, pos.lon);
        setState(() {
           _currentLocation = latlng;
           _isLocating = false; // GPS found, hide blocking spinner
        });
        
        _updateCamera();
        _addRedDot();

        // Background fetch address
        GeocodingService.reverseGeocode(pos.lat, pos.lon).then((addr) {
           if (mounted) setState(() {
             _currentAddress = addr ?? 'Tọa độ: ${pos.lat}, ${pos.lon}';
           });
        });
      } else {
        setState(() => _isLocating = false);
      }
    }
  }

  Future<void> _onMapClick(LatLng latlng) async {
    setState(() {
      _currentLocation = latlng;
      _isLocating = true;
    });
    
    // Update marker
    await _addRedDot();
    
    // Reverse geocode
    final addr = await GeocodingService.reverseGeocode(latlng.latitude, latlng.longitude);
    if (mounted) {
      setState(() {
        _currentAddress = addr ?? 'Tọa độ: ${latlng.latitude.toStringAsFixed(4)}, ${latlng.longitude.toStringAsFixed(4)}';
        _isLocating = false;
      });
    }
  }

  Future<void> _addRedDot() async {
    if (_mapController != null && _currentLocation != null) {
      // Remove previous dots if any (though typically not needed here)
      await _mapController!.addCircle(
        CircleOptions(
          geometry: _currentLocation!,
          circleColor: '#EF4444',
          circleRadius: 10.0,
          circleStrokeWidth: 4.0,
          circleStrokeColor: '#FFFFFF',
          circleOpacity: 0.8,
        ),
      );
    }
  }

  void _updateCamera() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15.0),
      );
    }
  }

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      _updateCamera();
      _addRedDot();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(isDark),
            const SizedBox(height: 24),
            _buildContactsGrid(isDark),
            const SizedBox(height: 24),
            _buildLocationCard(isDark),
            const SizedBox(height: 24),
            _buildFormSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: isDark ? const Color(0xFF991B1B) : const Color(0xFFDC2C4F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        shadows: [
          BoxShadow(
            color: isDark ? const Color(0x33EF4444) : const Color(0x26B90538),
            blurRadius: 32,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(Icons.sos, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GỬI LỜI CẦU CỨU',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFFEE2E2) : const Color(0xFFFFFBFF),
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    height: 1.33,
                    letterSpacing: -0.60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chức năng khẩn cấp - Sử dụng khi gặp nguy hiểm',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFFEE2E2) : const Color(0xFFFFFBFF).withAlpha(230),
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsGrid(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildContactItem(
              'CẢNH SÁT', '113', 
              isDark ? const Color(0x333B82F6) : const Color(0xFFDBEAFE), 
              isDark ? const Color(0xFF3B82F6) : const Color(0xFF0058BE), 
              width, Icons.local_police, isDark,
            ),
            _buildContactItem(
              'CỨU HỎA', '114', 
              isDark ? const Color(0x33EF4444) : const Color(0xFFFEE2E2), 
              isDark ? const Color(0xFFEF4444) : const Color(0xFFB90538), 
              width, Icons.local_fire_department, isDark,
            ),
            _buildContactItem(
              'CẤP CỨU', '115', 
              isDark ? const Color(0x3310B981) : const Color(0xFFD1FAE5), 
              isDark ? const Color(0xFF34D399) : const Color(0xFF059669), 
              width, Icons.medical_services, isDark,
            ),
            _buildContactItem(
              'SOS', '112', 
              isDark ? const Color(0x33F97316) : const Color(0xFFFFEDD5), 
              isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C), 
              width, Icons.support, isDark,
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactItem(String title, String number, Color bgColor, Color fgColor, double width, IconData icon, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: ShapeDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          side: isDark ? const BorderSide(width: 1, color: Color(0x33475569)) : BorderSide.none,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Icon(icon, color: fgColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          Text(
            number,
            style: TextStyle(color: fgColor, fontSize: 20, fontFamily: 'Manrope', fontWeight: FontWeight.w800, height: 1.40),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(bool isDark) {
    String coordsText = _currentLocation != null 
        ? '${_currentLocation!.latitude.toStringAsFixed(4)}° N, ${_currentLocation!.longitude.toStringAsFixed(4)}° E'
        : 'Đang lấy tọa độ...';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: isDark ? const Color(0xFF020617) : Colors.white,
        shape: RoundedRectangleBorder(
          side: isDark ? const BorderSide(width: 1, color: Color(0x19475569)) : BorderSide.none,
          borderRadius: BorderRadius.circular(isDark ? 40 : 32),
        ),
        shadows: isDark ? const [
          BoxShadow(color: Color(0x19000000), blurRadius: 10, offset: Offset(0, 8), spreadRadius: -6),
          BoxShadow(color: Color(0x19000000), blurRadius: 25, offset: Offset(0, 20), spreadRadius: -5),
        ] : const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vị trí của bạn', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF424754), fontSize: 14, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: _isLocating 
                      ? (isDark ? const Color(0x333B82F6) : const Color(0x190058BE))
                      : (isDark ? const Color(0x3310B981) : const Color(0x19059669)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                ),
                child: Text(
                  _isLocating ? 'ĐANG CẬP NHẬT' : 'ĐÃ XÁC ĐỊNH', 
                  style: TextStyle(
                    color: _isLocating 
                        ? (isDark ? const Color(0xFF3B82F6) : const Color(0xFF0058BE))
                        : (isDark ? const Color(0xFF34D399) : const Color(0xFF059669)), 
                    fontSize: 10, 
                    fontFamily: 'Manrope', 
                    fontWeight: FontWeight.w700
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: isDark ? Border.all(color: const Color(0x4C475569)) : null,
            ),
            child: Stack(
              children: [
                MapLibreMap(
                  onMapCreated: _onMapCreated,
                  onMapClick: (point, latlng) => _onMapClick(latlng),
                  styleString: "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=ZcFrRowz4bVq1wtlIWDvEikppTbC863E1oqcAycg",
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? const LatLng(16.047079, 108.206230), 
                    zoom: 14.0
                  ),
                  myLocationEnabled: true,
                  trackCameraPosition: true,
                ),
                
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: ShapeDecoration(
                      color: isDark ? const Color(0xE51E293B) : Colors.white.withValues(alpha: 0.9), 
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: isDark ? const Color(0x33475569) : const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Text(
                      coordsText, 
                      style: TextStyle(
                        color: isDark ? const Color(0xFF89ACFF) : const Color(0xFF0058BE), 
                        fontSize: 11, 
                        fontFamily: 'Manrope', 
                        fontWeight: FontWeight.w800
                      )
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: _initLocation,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: isDark ? const Color(0xE51E293B) : Colors.white.withAlpha(230), 
                        shape: const CircleBorder(),
                        shadows: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Icon(Icons.my_location, color: isDark ? const Color(0xFF89ACFF) : const Color(0xFF0058BE), size: 20),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: ShapeDecoration(
                      color: isDark ? const Color(0xE51E293B) : Colors.white.withAlpha(230), 
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: isDark ? const Color(0x33475569) : const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Text(
                      _currentAddress, 
                      style: TextStyle(
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B), 
                        fontSize: 11, 
                        fontFamily: 'Manrope', 
                        fontWeight: FontWeight.w500
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                if (_isLocating)
                  Container(
                    color: Colors.black.withAlpha(25),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _initLocation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 16, color: isDark ? const Color(0xFF89ACFF) : const Color(0xFF0058BE)),
                const SizedBox(width: 4),
                Text(
                  'Lấy lại vị trí hiện tại',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF89ACFF) : const Color(0xFF0058BE),
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldLabel('SỐ ĐIỆN THOẠI LIÊN HỆ', isDark, required: true),
        const SizedBox(height: 8),
        _buildTextField('Nhập số điện thoại của bạn...', isDark, controller: _phoneController, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextFieldLabel('SỐ NGƯỜI CẦN CỨU', isDark, required: true),
        const SizedBox(height: 8),
        _buildTextField('Nhập số lượng người...', isDark, controller: _peopleController, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextFieldLabel('MÔ TẢ TÌNH HUỐNG (KHÔNG BẮT BUỘC)', isDark, required: false),
        const SizedBox(height: 8),
        _buildTextField('Nhập chi tiết về tình trạng khẩn cấp hiện tại của bạn...', isDark, controller: _descController, maxLines: 4),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: isDark ? const Color(0xFF475569) : const Color(0xFFC2C6D6)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text('Đính kèm ảnh/video', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 14, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _isSubmitting ? null : _submitSos,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: ShapeDecoration(
              gradient: LinearGradient(colors: isDark ? const [Color(0xFFEF4444), Color(0xFF991B1B)] : const [Color(0xFFB90538), Color(0xFFDC2C4F)]),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              shadows: [BoxShadow(color: isDark ? const Color(0x4CEF4444) : const Color(0x3FB90538), blurRadius: 32, offset: const Offset(0, 12))],
            ),
            child: _isSubmitting 
              ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
              : const Text(
                  'GỬI CẦU CỨU NGAY',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.w800),
                ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _sendSmsSos,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: ShapeDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: isDark ? const Color(0xFFEF4444) : const Color(0xFFB90538)),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'GỬI QUA TIN NHẮN (SMS)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? const Color(0xFFEF4444) : const Color(0xFFB90538),
                fontSize: 18,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Lưu ý: Bạn phải hoàn toàn chịu trách nhiệm về thông tin cung cấp. Việc báo tin giả có thể bị truy cứu trách nhiệm hình sự theo quy định pháp luật.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontFamily: 'Manrope', fontWeight: FontWeight.w500, height: 1.63),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldLabel(String text, bool isDark, {bool required = false}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text, style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
          if (required) TextSpan(text: ' *', style: TextStyle(color: isDark ? const Color(0xFFEF4444) : const Color(0xFFBA1A1A), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, bool isDark, {required TextEditingController controller, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: ShapeDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF2F4F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B), fontSize: 14, fontFamily: 'Manrope'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 14, fontFamily: 'Manrope'),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
