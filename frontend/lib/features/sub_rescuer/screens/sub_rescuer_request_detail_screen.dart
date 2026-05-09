import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sub_rescuer_shell.dart';
import 'sub_rescuer_coordination_screen.dart';
import '../../../services/sos_service.dart';
import '../../../services/user_session.dart';

class SubRescuerRequestDetailScreen extends StatefulWidget {
  const SubRescuerRequestDetailScreen({super.key, required this.sosId});

  final String sosId;

  @override
  State<SubRescuerRequestDetailScreen> createState() => _SubRescuerRequestDetailScreenState();
}

class _SubRescuerRequestDetailScreenState extends State<SubRescuerRequestDetailScreen> {
  final SosService _sosService = SosService();
  SosRequestModel? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final token = UserSession().accessToken;
    final id = int.tryParse(widget.sosId);
    if (token == null || token.isEmpty || id == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final row = await _sosService.fetchSosById(sosId: id, token: token);
    if (!mounted) return;
    setState(() {
      _item = row;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Text(
          'Chi tiết yêu cầu',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: cs.onSurface, letterSpacing: 0.4),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _item?.phoneNumber ?? 'Người cầu cứu',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: cs.onSurface),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _item?.status ?? 'PENDING',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFB91C1C)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Mã ca: #${widget.sosId}', style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(
                    'Số người cần cứu: ${_item?.peopleCount ?? 1}',
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(_item?.phoneNumber ?? '0901 234 567', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => launchUrl(Uri.parse('tel:${_item?.phoneNumber ?? '0901234567'}')),
                    icon: const Icon(Icons.call_rounded),
                    label: const Text('Gọi ngay'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailMapPreview(
                  lat: _item?.lat,
                  lng: _item?.lng,
                  loading: _loading,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _item?.description?.trim().isNotEmpty == true
                            ? _item!.description!.trim()
                            : 'Vị trí theo tọa độ GPS người cầu cứu',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: cs.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _item?.lat != null && _item?.lng != null
                            ? 'GPS: ${_item!.lat!.toStringAsFixed(5)}, ${_item!.lng!.toStringAsFixed(5)}'
                            : 'Chưa có tọa độ GPS',
                        style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mô tả tình huống', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
                  const SizedBox(height: 8),
                  Text(
                    _item?.description?.trim().isNotEmpty == true
                        ? _item!.description!.trim()
                        : 'Chưa có mô tả chi tiết từ người cầu cứu.',
                    style: TextStyle(fontSize: 14, height: 1.45, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, index) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => Container(
                        width: 112,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.orange.shade200, Colors.red.shade300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Từ chối'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => SubRescuerCoordinationScreen(sosId: widget.sosId),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Chấp nhận'),
                ),
              ),
            ],
          ),
        ],
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

class _DetailMapPreview extends StatefulWidget {
  const _DetailMapPreview({
    required this.lat,
    required this.lng,
    required this.loading,
  });

  final double? lat;
  final double? lng;
  final bool loading;

  @override
  State<_DetailMapPreview> createState() => _DetailMapPreviewState();
}

class _DetailMapPreviewState extends State<_DetailMapPreview> {
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
    if (widget.loading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_hasCoords) {
      return Container(
        height: 200,
        width: double.infinity,
        color: const Color(0xFFF1F5F9),
        alignment: Alignment.center,
        child: const Text('Ca này chưa có tọa độ để hiển thị bản đồ'),
      );
    }

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: MapLibreMap(
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoaded,
        styleString:
            "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=ZcFrRowz4bVq1wtlIWDvEikppTbC863E1oqcAycg",
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat!, widget.lng!),
          zoom: 14.5,
        ),
        myLocationEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        trackCameraPosition: false,
        attributionButtonPosition: null,
      ),
    );
  }
}
