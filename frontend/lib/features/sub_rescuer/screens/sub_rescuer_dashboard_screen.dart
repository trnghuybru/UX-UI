import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'sub_rescuer_coordination_screen.dart';
import 'sub_rescuer_request_detail_screen.dart';
import '../../../services/sos_service.dart';
import '../../../services/user_session.dart';

class SubRescuerDashboardScreen extends StatefulWidget {
  const SubRescuerDashboardScreen({super.key, this.onSwitchTab});

  final ValueChanged<int>? onSwitchTab;

  @override
  State<SubRescuerDashboardScreen> createState() => _SubRescuerDashboardScreenState();
}

class _SubRescuerDashboardScreenState extends State<SubRescuerDashboardScreen> {
  final SosService _sosService = SosService();
  final Location _location = Location();
  List<SosRequestModel> _requests = const [];
  bool _loading = true;
  String? _error;
  double? _currentLat;
  double? _currentLng;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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

    await _tryFetchLocation();
    final rows = await _sosService.fetchEmergencySosRequests(token: token);

    if (!mounted) return;
    setState(() {
      _requests = rows.where((r) {
        final s = r.status.toUpperCase();
        return s != 'COMPLETED' && s != 'FAILED' && s != 'CANCELLED';
      }).toList();
      _loading = false;
    });
  }

  Future<void> _tryFetchLocation() async {
    try {
      final hasService = await _location.serviceEnabled() || await _location.requestService();
      if (!hasService) return;
      var permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }
      if (permission != PermissionStatus.granted && permission != PermissionStatus.grantedLimited) return;
      final loc = await _location.getLocation();
      if (!mounted) return;
      setState(() {
        _currentLat = loc.latitude;
        _currentLng = loc.longitude;
      });
    } catch (_) {}
  }

  double? _distanceKm(SosRequestModel r) {
    if (_currentLat == null || _currentLng == null || r.lat == null || r.lng == null) return null;
    const rad = 0.017453292519943295;
    final dLat = (r.lat! - _currentLat!) * rad;
    final dLng = (r.lng! - _currentLng!) * rad;
    final a = 0.5 - math.cos(dLat) / 2 + math.cos(_currentLat! * rad) * math.cos(r.lat! * rad) * (1 - math.cos(dLng)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  SosRequestModel? get _nearest {
    if (_requests.isEmpty) return null;
    if (_currentLat == null || _currentLng == null) return _requests.first;
    final sorted = [..._requests];
    sorted.sort((a, b) {
      final da = _distanceKm(a) ?? 999999;
      final db = _distanceKm(b) ?? 999999;
      return da.compareTo(db);
    });
    return sorted.first;
  }

  Future<void> _acceptCase(SosRequestModel item) async {
    final isInProgress = item.status.toUpperCase() == 'IN_PROGRESS';
    if (isInProgress) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SubRescuerCoordinationScreen(sosId: item.id.toString()),
        ),
      );
      return;
    }

    final token = UserSession().accessToken;
    if (token == null || token.isEmpty) return;
    final ok = await _sosService.acceptSosRequest(sosId: item.id, token: token);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể nhận ca. Có thể ca đã được người khác nhận.')),
      );
      await _loadData();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã nhận ca #${item.id}. Bắt đầu điều phối ngay.')),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                          'Xin chào',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0058BE), Color(0xFF2170E4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0058BE).withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chào buổi sáng, cứu hộ viên',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatChip(
                            label: 'Ca đang mở',
                            value: _requests.length.toString().padLeft(2, '0'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatChip(
                            label: 'Ca chờ xử lý',
                            value: _requests
                                .where((x) => x.status.toUpperCase() == 'PENDING')
                                .length
                                .toString()
                                .padLeft(2, '0'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _EmergencyCard(
                loading: _loading,
                error: _error,
                item: _nearest,
                distanceKm: _nearest == null ? null : _distanceKm(_nearest!),
                isInProgress: _nearest?.status.toUpperCase() == 'IN_PROGRESS',
                onReload: _loadData,
                onSeeAll: () => widget.onSwitchTab?.call(1),
                onAccept: _nearest == null ? null : () => _acceptCase(_nearest!),
                onDetail: _nearest == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => SubRescuerRequestDetailScreen(sosId: _nearest!.id.toString()),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _QuickTile(icon: Icons.phone_in_talk_rounded, label: 'Liên lạc')),
                  const SizedBox(width: 8),
                  Expanded(child: _QuickTile(icon: Icons.medical_services_outlined, label: 'Sơ cứu')),
                  const SizedBox(width: 8),
                  Expanded(child: _QuickTile(icon: Icons.map_outlined, label: 'Bản đồ')),
                  const SizedBox(width: 8),
                  Expanded(child: _QuickTile(icon: Icons.share_rounded, label: 'Chia sẻ')),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.wb_cloudy_outlined, color: cs.primary, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thời tiết', style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface)),
                          Text('TP.HCM · Nắng nhẹ', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Text(
                      '32°C',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: cs.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, color: Colors.amber.shade900, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ĐANG XỬ LÝ: Đồng đội đang cập nhật tiến độ ca gần nhất.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => widget.onSwitchTab?.call(1),
                  child: const Text('Xem danh sách yêu cầu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.85),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard({
    required this.loading,
    required this.error,
    required this.item,
    required this.distanceKm,
    required this.isInProgress,
    required this.onReload,
    required this.onSeeAll,
    required this.onAccept,
    required this.onDetail,
  });

  final bool loading;
  final String? error;
  final SosRequestModel? item;
  final double? distanceKm;
  final bool isInProgress;
  final VoidCallback onReload;
  final VoidCallback onSeeAll;
  final VoidCallback? onAccept;
  final VoidCallback? onDetail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Yêu cầu khẩn cấp',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cs.onSurface),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onSeeAll,
                icon: const Icon(Icons.list_alt_rounded, size: 18),
                label: const Text('Xem tất cả'),
              ),
            ],
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(error!, style: TextStyle(fontSize: 13, color: cs.error)),
                  const SizedBox(height: 8),
                  OutlinedButton(onPressed: onReload, child: const Text('Thử lại')),
                ],
              ),
            )
          else if (item == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Hiện chưa có lời cầu cứu nào đang mở.'),
            )
          else ...[
            const SizedBox(height: 12),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                'Gần nhất',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: cs.primary),
              ),
            ),
            const SizedBox(height: 12),
            _EmergencyMapPreview(
              lat: item!.lat,
              lng: item!.lng,
            ),
            const SizedBox(height: 12),
            Text(item!.type ?? 'Yêu cầu cứu hộ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
            const SizedBox(height: 4),
            Text(
              item!.description?.trim().isNotEmpty == true ? item!.description!.trim() : 'Người dân cần hỗ trợ khẩn cấp.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Row(
            children: [
              Text(
                distanceKm == null ? 'Khoảng cách: chưa xác định' : 'Khoảng cách: ${distanceKm!.toStringAsFixed(2)} km',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              Text('Mã ca #${item!.id}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: cs.primary)),
            ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: onSeeAll,
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text('Xem tất cả lời cầu cứu hiện tại'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onAccept,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isInProgress ? 'Quay trở lại' : 'Chấp nhận cứu hộ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDetail,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Xem chi tiết'),
                ),
              ),
            ],
          ),
          ],
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _EmergencyMapPreview extends StatefulWidget {
  const _EmergencyMapPreview({
    required this.lat,
    required this.lng,
  });

  final double? lat;
  final double? lng;

  @override
  State<_EmergencyMapPreview> createState() => _EmergencyMapPreviewState();
}

class _EmergencyMapPreviewState extends State<_EmergencyMapPreview> {
  MapLibreMapController? _controller;

  bool get _hasCoords => widget.lat != null && widget.lng != null;

  void _onMapCreated(MapLibreMapController controller) {
    _controller = controller;
  }

  void _onStyleLoaded() {
    if (!_hasCoords || _controller == null) return;
    final pos = LatLng(widget.lat!, widget.lng!);
    _controller!.clearSymbols();
    _controller!.addCircle(
      CircleOptions(
        geometry: pos,
        circleColor: '#B90538',
        circleRadius: 7.0,
        circleStrokeWidth: 2.0,
        circleStrokeColor: '#FFFFFF',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCoords) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 160,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFEE2E2), Color(0xFFFCA5A5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Text(
            'Ca này chưa có tọa độ để hiển thị bản đồ',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF7F1D1D)),
          ),
        ),
      );
    }

    final camera = CameraPosition(target: LatLng(widget.lat!, widget.lng!), zoom: 14.5);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 180,
        child: MapLibreMap(
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: _onStyleLoaded,
          styleString:
              "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=ZcFrRowz4bVq1wtlIWDvEikppTbC863E1oqcAycg",
          initialCameraPosition: camera,
          myLocationEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          trackCameraPosition: false,
          attributionButtonPosition: null,
        ),
      ),
    );
  }
}
