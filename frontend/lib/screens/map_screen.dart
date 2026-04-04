import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_toggle_bar.dart';
import 'shelter_registration_screen.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/shelter_model.dart';
import '../services/shelter_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedFilterIndex = 0;
  MapLibreMapController? _mapController;
  bool _isStyleLoaded = false;
  List<ShelterModel> _shelters = [];
  bool _isLoadingShelters = false;
  final ShelterService _shelterService = ShelterService();

  // Locations
  static const _hn = LatLng(21.03357551700003, 105.81911236900004);
  static const _dn = LatLng(16.047079, 108.206230);

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoadedCallback() {
    setState(() => _isStyleLoaded = true);
    _addShelterMarkers();
  }

  Future<void> _fetchShelters() async {
    setState(() {
      _isLoadingShelters = true;
    });

    try {
      final shelters = await _shelterService.fetchShelters();
      if (mounted) {
        setState(() {
          _shelters = shelters;
          _isLoadingShelters = false;
        });
        _addShelterMarkers();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingShelters = false;
        });
      }
    }
  }

  void _addShelterMarkers() {
    if (!_isStyleLoaded || _mapController == null || _shelters.isEmpty) return;

    // Optional: Clear existing symbols if needed, but here we just add them
    for (final shelter in _shelters) {
      _mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(shelter.lat, shelter.lng),
          iconImage: "marker-15", // Default marker, might need to load custom if desired
          textField: shelter.name,
          textOffset: const Offset(0, 2),
          textColor: '#2E7D32',
          textSize: 12.0,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _fetchShelters();
  }

  Future<void> _requestPermissions() async {
    if (!const bool.fromEnvironment('dart.library.html')) {
      await Permission.locationWhenInUse.request();
    }
  }

  void _updateCamera(int index) {
    if (_mapController == null) return;
    
    LatLng target;
    double zoom;
    
    if (index == 0) {
      target = _hn;
      zoom = 14.0;
    } else if (index == 1) {
      target = _dn;
      zoom = 6.0;
    } else {
      target = _dn;
      zoom = 13.0;
    }
    
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: zoom),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 135),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMapSection(),
                    const SizedBox(height: 16),
                    CustomToggleBar(
                      labels: const ['Cảnh báo', 'Gió bão', 'Trú ẩn'],
                      selectedIndex: _selectedFilterIndex,
                      onSelectedIndexChanged: (index) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                        _updateCamera(index);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDynamicContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    double height = _selectedFilterIndex == 0 ? 450 : (_selectedFilterIndex == 1 ? 340 : 320);
    
    return Container(
      width: double.infinity,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF0),
        borderRadius: BorderRadius.circular(_selectedFilterIndex == 0 ? 32 : 24),
        border: Border.all(color: const Color(0x19C2C6D6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x190058BE),
            blurRadius: 50,
            offset: Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // SINGLE MAP INSTANCE
          Positioned.fill(
            child: MapLibreMap(
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              styleString: "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=jTmhSjJz211NLnmhk3nV79bvgmehQxgNhiIUGDWT",
              initialCameraPosition: const CameraPosition(target: _hn, zoom: 14.0),
              myLocationEnabled: _selectedFilterIndex == 0,
              trackCameraPosition: true,
              attributionButtonPosition: null,
            ),
          ),

          // OVERLAYS BASED ON FILTER
          if (_selectedFilterIndex == 0) ..._buildNormalOverlays(),
          if (_selectedFilterIndex == 1) ..._buildStormOverlays(),
          if (_selectedFilterIndex == 2) ..._buildShelterOverlays(),
        ],
      ),
    );
  }

  List<Widget> _buildNormalOverlays() {
    return [
      Positioned(left: 120, top: 150, child: _buildMapBadge('NGUY HIỂM CAO', const Color(0xFFB90538))),
      Positioned(left: 180, top: 250, child: _buildMapBadge('CẢNH BÁO', const Color(0xFFF97316))),
      Positioned(left: 200, top: 320, child: _buildMapBadge('THEO DÕI', const Color(0xFFEAB308))),
      Positioned(
        right: 16,
        top: 16,
        child: Column(
          spacing: 8,
          children: [
            _buildMapControlButton(Icons.layers_outlined),
            _buildMapControlButton(Icons.my_location),
            _buildMapControlButton(Icons.map, backgroundColor: const Color(0xFF0058BE), iconColor: Colors.white),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildStormOverlays() {
    return [
      Positioned.fill(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xE5F7F9FB), Color(0x00F7F9FB), Color(0x00F7F9FB), Color(0xE5F7F9FB)],
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFB90538),
            shape: BoxShape.circle,
            border: Border.all(width: 4, color: Colors.white),
          ),
        ),
      ),
      Positioned(
        right: 16,
        top: 16,
        child: Column(
          spacing: 8,
          children: [
            _buildMapControlButton(Icons.add),
            _buildMapControlButton(Icons.remove),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildShelterOverlays() {
    return [
      // Dynamic badges from API could be handled via MapLibre Symbols implemented above.
      // We can also use Positioned widgets if we want custom Flutter UI on top of map,
      // but Symbols are generally better for performance and panning.
      if (_shelters.isNotEmpty) 
        ..._shelters.take(2).map((s) => Positioned(
          // This is a simplified positioning for demonstration on top of the stack,
          // in a real app you'd typically use MapLibre Symbols for this.
          left: 100.0 + (s.id * 50) % 200, 
          top: 80.0 + (s.id * 80) % 150,
          child: _buildShelterMapBadge(s.name)
        )),
      Positioned(
        bottom: 24,
        left: 0,
        right: 0,
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ShelterRegistrationScreen()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 32, offset: Offset(0, 12))],
              ),
              child: const Text(
                'Đăng ký địa điểm trú ẩn',
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: -0.40),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildMapBadge(String text, Color color) {
    return Column(
      children: [
        Icon(Icons.location_on, color: color, size: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [BoxShadow(color: Color(0x19000000), blurRadius: 3, offset: Offset(0, 4))],
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: 1)),
        ),
      ],
    );
  }

  Widget _buildShelterMapBadge(String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Color(0x4CFFFFFF), blurRadius: 0, spreadRadius: 4)],
          ),
          child: const Icon(Icons.home, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))],
          ),
          child: Text(name, style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 10, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildMapControlButton(IconData icon, {Color backgroundColor = Colors.white, Color iconColor = const Color(0xFF5A5F6B)}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x19000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
          BoxShadow(color: Color(0x19000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildDynamicContent() {
    if (_selectedFilterIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAlertLevels(),
          const SizedBox(height: 24),
          _buildAlertHeader(),
          const SizedBox(height: 24),
          _buildAlertList(),
        ],
      );
    } else if (_selectedFilterIndex == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStormWarningCard(),
          const SizedBox(height: 16),
          _buildIntensityZonesCard(),
          const SizedBox(height: 16),
          _buildRouteUpdateInfo(),
        ],
      );
    } else {
      return _buildShelterTabContent();
    }
  }

  // --- TAB CẢNH BÁO --- //
  Widget _buildAlertLevels() {
    return Column(
      spacing: 8,
      children: [
        _buildAlertLevelItem(const Color(0xFFB90538), 'MỨC ĐỘ 3', 'Nguy hiểm cao'),
        _buildAlertLevelItem(const Color(0xFFF97316), 'MỨC ĐỘ 2', 'Cảnh báo'),
        _buildAlertLevelItem(const Color(0xFFEAB308), 'MỨC ĐỘ 1', 'Theo dõi'),
      ],
    );
  }

  Widget _buildAlertLevelItem(Color color, String subtitle, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0x19C2C6D6))),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 0, spreadRadius: 4)]),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: const TextStyle(color: Color(0xFF727785), fontSize: 10, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: 0.50, height: 1.5)),
              Text(title, style: const TextStyle(color: Color(0xFF191C1E), fontSize: 16, fontFamily: 'Manrope', fontWeight: FontWeight.w700, height: 1.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Điểm cảnh báo', style: TextStyle(color: Color(0xFF191C1E), fontSize: 24, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: -0.60, height: 1.33)),
            SizedBox(height: 4),
            Text('Danh sách khu vực cần theo dõi sát sao', style: TextStyle(color: Color(0xFF424754), fontSize: 14, fontFamily: 'Manrope', height: 1.43)),
          ],
        ),
        const Text('Xem tất cả', style: TextStyle(color: Color(0xFF0058BE), fontSize: 14, fontFamily: 'Manrope', fontWeight: FontWeight.w700, height: 1.43)),
      ],
    );
  }

  Widget _buildAlertList() {
    return Column(
      spacing: 12,
      children: [
        _buildAlertListItem(location: 'Quảng Trị', issue: 'Lốc xoáy', issueColor: const Color(0xFFFFB2B7), issueTextColor: const Color(0xFF40000D), severity: 'Nguy hiểm cao', severityColor: const Color(0xFFB90538), iconBgColor: const Color(0xFFFFDADB), iconColor: const Color(0xFFB90538), icon: Icons.air),
        _buildAlertListItem(location: 'Đà Nẵng', issue: 'Sạt lở', issueColor: const Color(0xFFFFDDB2), issueTextColor: const Color(0xFF4D2400), severity: 'Cảnh báo', severityColor: const Color(0xFFF97316), iconBgColor: const Color(0xFFFFEDD5), iconColor: const Color(0xFFF97316), icon: Icons.landslide),
      ],
    );
  }

  Widget _buildAlertListItem({required String location, required String issue, required Color issueColor, required Color issueTextColor, required String severity, required Color severityColor, required Color iconBgColor, required Color iconColor, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: iconColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location, style: const TextStyle(color: Color(0xFF191C1E), fontSize: 16, fontFamily: 'Manrope', fontWeight: FontWeight.w700, height: 1.5)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: issueColor, borderRadius: BorderRadius.circular(6)), child: Text(issue, style: TextStyle(color: issueTextColor, fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w600, height: 1.33))),
                    const SizedBox(width: 8),
                    Text('• $severity', style: TextStyle(color: severityColor, fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w700, height: 1.33)),
                  ],
                ),
              ],
            ),
          ),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF2F4F6), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5A5F6B))),
        ],
      ),
    );
  }

  // --- TAB GIÓ BÃO --- //
  Widget _buildStormWarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0x19C2C6D6)), boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('CẢNH BÁO KHẨN CẤP', style: TextStyle(color: Color(0xFFB90538), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: 1.20)),
                  SizedBox(height: 4),
                  Text('Bão số 5', style: TextStyle(color: Color(0xFF191C1E), fontSize: 30, fontFamily: 'Manrope', fontWeight: FontWeight.w800, letterSpacing: -0.75)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFDADB), borderRadius: BorderRadius.circular(9999)),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: Color(0xFFB90538), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    const Text('Đang hoạt động', style: TextStyle(color: Color(0xFFB90538), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 12,
            children: [
              Expanded(child: _buildStormStatCard('SỨC GIÓ', '120', 'km/h')),
              Expanded(child: _buildStormStatCard('HƯỚNG', 'Tây Bắc', '')),
              Expanded(child: _buildStormStatCard('ÁP SUẤT', '960', 'hPa')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStormStatCard(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF727785), fontSize: 10, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: 0.50)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(color: Color(0xFF191C1E), fontSize: 18, fontFamily: 'Manrope', fontWeight: FontWeight.w800)),
            const SizedBox(width: 4),
            Text(unit, style: const TextStyle(color: Color(0xFF727785), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildIntensityZonesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VÙNG ẢNH HƯỞNG', style: TextStyle(color: Color(0xFF727785), fontSize: 10, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: 0.50)),
          const SizedBox(height: 12),
          _buildZoneItem(const Color(0xFFB90538), 'Vùng lõi (Nguy kịch)', 'Gần tâm bão, sức gió > 118km/h'),
          const Divider(height: 24, color: Color(0x19C2C6D6)),
          _buildZoneItem(const Color(0xFFF97316), 'Vùng gió mạnh', 'Sức gió 89-117km/h'),
        ],
      ),
    );
  }

  Widget _buildZoneItem(Color color, String title, String desc) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF191C1E), fontSize: 14, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
              Text(desc, style: const TextStyle(color: Color(0xFF727785), fontSize: 12, fontFamily: 'Manrope')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteUpdateInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF0058BE), size: 20),
          const SizedBox(width: 12),
          const Expanded(child: Text('Lộ trình dự kiến bão có thể thay đổi trong 12h tới do áp cao cận nhiệt đới.', style: TextStyle(color: Color(0xFF003D82), fontSize: 12, fontFamily: 'Manrope', height: 1.5))),
        ],
      ),
    );
  }

  // --- TAB TRÚẨN --- //
  Widget _buildShelterTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShelterStatusHeader(),
        const SizedBox(height: 24),
        _buildShelterList(),
      ],
    );
  }

  Widget _buildShelterStatusHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Điểm trú ẩn', style: TextStyle(color: Color(0xFF191C1E), fontSize: 24, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: -0.60)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(9999)),
          child: const Text('24 điểm sẵn sàng', style: TextStyle(color: Color(0xFF166534), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildShelterList() {
    if (_isLoadingShelters) {
      return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
    }

    if (_shelters.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('Không tìm thấy điểm trú ẩn nào')));
    }

    return Column(
      spacing: 12,
      children: _shelters.map((shelter) => _buildShelterListItem(
        shelter.name, 
        shelter.address, 
        shelter.currentPeople, 
        shelter.capacity, 
        // We'll use a placeholder for distance or calculate it if user location is available
        2.5 
      )).toList(),
    );
  }

  Widget _buildShelterListItem(String name, String address, int current, int capacity, double distance) {
    double fillPercent = current / capacity;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.home_work_outlined, color: Color(0xFF166534))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Color(0xFF191C1E), fontSize: 16, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(address, style: const TextStyle(color: Color(0xFF727785), fontSize: 12, fontFamily: 'Manrope')),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$distance km', style: const TextStyle(color: Color(0xFF166534), fontSize: 14, fontFamily: 'Manrope', fontWeight: FontWeight.w800)),
                  const Text('Cách đây', style: TextStyle(color: Color(0xFF727785), fontSize: 10, fontFamily: 'Manrope')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Công suất: $current/$capacity người', style: const TextStyle(color: Color(0xFF424754), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w600)),
              Text('${(fillPercent * 100).toInt()}%', style: TextStyle(color: fillPercent > 0.9 ? const Color(0xFFB90538) : const Color(0xFF166534), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFF2F4F6), borderRadius: BorderRadius.circular(3)),
            child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: fillPercent, child: Container(decoration: BoxDecoration(color: fillPercent > 0.9 ? const Color(0xFFB90538) : const Color(0xFF166534), borderRadius: BorderRadius.circular(3)))),
          ),
        ],
      ),
    );
  }
}
