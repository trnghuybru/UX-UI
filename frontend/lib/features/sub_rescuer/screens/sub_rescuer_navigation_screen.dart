import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sub_rescuer_shell.dart';
import '../../../services/directions_service.dart';
import '../../../services/location_service.dart';
import '../../../services/sos_service.dart';
import '../../../services/user_session.dart';
import 'sub_rescuer_chat_screen.dart';
import 'sub_rescuer_progress_screen.dart';

class SubRescuerNavigationScreen extends StatefulWidget {
  const SubRescuerNavigationScreen({super.key, required this.sosId});

  final String sosId;

  @override
  State<SubRescuerNavigationScreen> createState() => _SubRescuerNavigationScreenState();
}

class _SubRescuerNavigationScreenState extends State<SubRescuerNavigationScreen> {
  final SosService _sosService = SosService();
  MapLibreMapController? _mapController;
  bool _isStyleLoaded = false;
  bool _isLoadingRoute = true;
  String? _error;
  SosRequestModel? _sos;
  List<LatLng> _routePoints = const [];
  List<RouteStep> _steps = const [];
  double _distanceKm = 0.0;

  String get _nextInstruction {
    if (_steps.isEmpty) return 'Đang tìm lộ trình tối ưu...';
    final raw = _steps.first.instruction;
    final cleaned = raw.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    return cleaned.isEmpty ? 'Di chuyển theo lộ trình trên bản đồ' : cleaned;
  }

  String get _etaText {
    if (_distanceKm <= 0) return '~ -- phút';
    final minutes = (_distanceKm / 30.0 * 60).round(); // 30km/h nội đô
    return '~ $minutes phút';
    }

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoadedCallback() {
    setState(() => _isStyleLoaded = true);
    _loadAndDrawRoute();
  }

  Future<void> _loadAndDrawRoute() async {
    if (!_isStyleLoaded || _mapController == null) return;
    setState(() {
      _isLoadingRoute = true;
      _error = null;
    });

    final token = UserSession().accessToken;
    final sosId = int.tryParse(widget.sosId);
    if (token == null || token.isEmpty || sosId == null) {
      setState(() {
        _error = 'Không lấy được phiên đăng nhập hoặc mã ca.';
        _isLoadingRoute = false;
      });
      return;
    }

    final sos = await _sosService.fetchSosById(sosId: sosId, token: token);
    if (sos == null || sos.lat == null || sos.lng == null) {
      setState(() {
        _error = 'Ca này chưa có tọa độ để chỉ đường.';
        _isLoadingRoute = false;
      });
      return;
    }

    final current = await LocationService.getCurrentLocation();
    if (current == null) {
      setState(() {
        _error = 'Không thể lấy vị trí hiện tại của bạn.';
        _isLoadingRoute = false;
      });
      return;
    }

    final origin = LatLng(current.lat, current.lon);
    final destination = LatLng(sos.lat!, sos.lng!);
    final route = await DirectionsService.getRoute(origin, destination);

    if (route.points.isEmpty) {
      setState(() {
        _sos = sos;
        _error = 'Goong chưa trả về lộ trình (${route.status}).';
        _isLoadingRoute = false;
      });
      return;
    }

    await _mapController?.clearLines();
    await _mapController?.clearCircles();

    await _mapController?.addCircle(
      CircleOptions(
        geometry: origin,
        circleColor: '#3B82F6',
        circleRadius: 7,
        circleStrokeWidth: 2,
        circleStrokeColor: '#FFFFFF',
      ),
    );
    await _mapController?.addLine(
      LineOptions(
        geometry: route.points,
        lineColor: '#0058BE',
        lineWidth: 6.0,
        lineOpacity: 0.9,
        lineJoin: 'round',
      ),
    );
    await _mapController?.addCircle(
      CircleOptions(
        geometry: destination,
        circleColor: '#EF4444',
        circleRadius: 9,
        circleStrokeWidth: 3,
        circleStrokeColor: '#FFFFFF',
      ),
    );

    double minLat = origin.latitude;
    double maxLat = origin.latitude;
    double minLng = origin.longitude;
    double maxLng = origin.longitude;
    for (final p in route.points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        left: 32,
        top: 120,
        right: 32,
        bottom: 220,
      ),
    );

    if (!mounted) return;
    setState(() {
      _sos = sos;
      _routePoints = route.points;
      _steps = route.steps;
      _distanceKm = LocationService.calculateDistance(origin.latitude, origin.longitude, destination.latitude, destination.longitude);
      _isLoadingRoute = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapLibreMap(
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            styleString: 'https://tiles.goong.io/assets/navigation_day.json?api_key=ZcFrRowz4bVq1wtlIWDvEikppTbC863E1oqcAycg',
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.7769, 106.7009),
              zoom: 13,
            ),
            myLocationEnabled: true,
            trackCameraPosition: false,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.95),
                          foregroundColor: const Color(0xFF1F2937),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.95),
                          foregroundColor: const Color(0xFF0058BE),
                        ),
                        onPressed: _loadAndDrawRoute,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0058BE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _nextInstruction,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FloatingStat(label: _distanceKm > 0 ? '${_distanceKm.toStringAsFixed(1)} km' : '-- km'),
                      _FloatingStat(label: _etaText),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Material(
                        color: Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(20),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _sos?.phoneNumber ?? 'Người cần hỗ trợ',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _sos?.description?.trim().isNotEmpty == true
                                    ? _sos!.description!.trim()
                                    : 'Mã ca #${widget.sosId}',
                                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () {
                                        final phone = _sos?.phoneNumber;
                                        if (phone == null || phone.trim().isEmpty) return;
                                        launchUrl(Uri.parse('tel:$phone'));
                                      },
                                      icon: const Icon(Icons.call_rounded),
                                      label: const Text('Gọi điện'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) => SubRescuerChatScreen(sosId: widget.sosId),
                                          ),
                                        );
                                      },
                                      child: const Text('Nhắn tin'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => SubRescuerProgressScreen(sosId: widget.sosId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.timeline_rounded),
                          label: const Text('Mở tiến độ ca'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0058BE),
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoadingRoute)
            Container(
              color: Colors.black.withValues(alpha: 0.25),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          if (!_isLoadingRoute && _error != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 190,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F1D1D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: 1,
        indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
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

class _FloatingStat extends StatelessWidget {
  const _FloatingStat({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
      ),
    );
  }
}
