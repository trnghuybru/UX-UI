import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_toggle_bar.dart';
import 'shelter_registration_screen.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/shelter_model.dart';
import '../services/shelter_service.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';
import 'navigation_screen.dart';
import '../services/socket_service.dart';

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
  Line? _currentRoute;
  LatLng? _userLocation;
  Fill? _radiusFill;
  Line? _radiusOutline;
  Circle? _userMarkerCircle;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  bool _hasFetchedInitialShelters = false;
  final SocketService _socketService = SocketService();
  
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // 1. Fetch shelters immediately (may use cache)
    _fetchShelters();
    
    // 2. Request permissions FIRST and wait
    await LocationService.requestPermissions();
    
    // 3. Start dynamic location tracking
    _initLocationTracking();
    
    // 4. Initialize WebSocket
    _socketService.initSocket(onShelterUpdate: (data) {
      debugPrint('🔔 Map received real-time update: $data');
      if (mounted) {
        // Just a tiny feedback to know it arrived!
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🏠 Phát hiện địa điểm trú ẩn mới! Đang cập nhật...'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        _fetchShelters();
      }
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _locationSubscription?.cancel();
    super.dispose();
  }

  // Locations
  static const _hn = LatLng(21.03357551700003, 105.81911236900004);
  static const _dn = LatLng(15.978765, 108.236751);

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoadedCallback() {
    setState(() => _isStyleLoaded = true);
    _addShelterMarkers();
  }

  Future<void> _fetchShelters() async {
    if (_isLoadingShelters) return; // Concurrency protection
    
    // Only show loading spinner on initial fetch
    if (mounted && _shelters.isEmpty) {
      setState(() {
        _isLoadingShelters = true;
      });
    }

    try {
      // 1. Get current user location
      // Optimization: if we already have a location from tracking, use it!
      final userLatLng = _userLocation;
      
      // If we don't even have a cached one, we can try to fetch it once,
      // but let's be fast. Skip if we already have it.
      if (userLatLng == null) {
          // just try a quick fetch if first time
          LocationService.getCurrentLocation().then((pos) {
             if (pos != null && mounted) setState(() => _userLocation = LatLng(pos.lat, pos.lon));
          });
      }
 
      // 2. Fetch all shelters
      final allShelters = await _shelterService.fetchShelters();
      
      // LOG FOR VERIFICATION
      debugPrint('FETCHED SHELTERS FROM BACKEND: ${allShelters.length}');
      for (var s in allShelters) {
        debugPrint('Shelter: ${s.name} at [${s.lat}, ${s.lng}]');
      }
 
      if (mounted) {
        setState(() {
          _userLocation = userLatLng;
          _isLoadingShelters = false;
          
          if (userLatLng != null) {
            // 3. Try to filter by 15km
            _shelters = allShelters.where((s) {
              double dist = LocationService.calculateDistance(
                userLatLng.latitude, userLatLng.longitude, 
                s.lat, s.lng
              );
              return dist <= 15.0;
            }).toList();
            
            // If none found within 15km, show all as fallback but keep sorting 
            // by distance if location available
            if (_shelters.isEmpty) {
              _shelters = List.from(allShelters);
            }
            
            // Sort by distance to user
            _shelters.sort((a, b) {
              double da = LocationService.calculateDistance(userLatLng.latitude, userLatLng.longitude, a.lat, a.lng);
              double db = LocationService.calculateDistance(userLatLng.latitude, userLatLng.longitude, b.lat, b.lng);
              return da.compareTo(db);
            });
          } else {
             _shelters = allShelters; // Show all if location unavailable
          }
        });
        
        if (userLatLng != null) {
           _addShelterMarkers();
           _updateRadiusVisuals(userLatLng);
        } else {
           _addShelterMarkers(); // Draw on map even without user circle
        }
        
        // Auto center on user when tab 2 is active
        if (_selectedFilterIndex == 2 && userLatLng != null) {
          _updateCamera(2);
        }
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

    _mapController!.clearSymbols();
    _mapController!.clearCircles(); // Clear any existing shelter dots
    
    // Re-draw the user circle (since we cleared all circles)
    if (_userLocation != null) _updateUserMarker(_userLocation!);

    for (final shelter in _shelters) {
      final pos = LatLng(shelter.lat, shelter.lng);
      
      // 1. Add a small pinpoint circle for 100% accuracy
      _mapController!.addCircle(
        CircleOptions(
          geometry: pos,
          circleColor: '#166534', // Same green as brand
          circleRadius: 8.0, // Increased size for visibility
          circleStrokeWidth: 2.0,
          circleStrokeColor: '#FFFFFF',
        )
      );

      // 2. Add the descriptive name
      _mapController!.addSymbol(
        SymbolOptions(
          geometry: pos,
          textField: shelter.name,
          textOffset: const Offset(0, -1.8), // Offset text to be above the circle
          textColor: '#1B5E20',
          textSize: 11.5,
          textHaloBlur: 1.0,
          textHaloColor: '#FFFFFF',
          textHaloWidth: 0.8,
        ),
      );
    }
  }


  Future<void> _initLocationTracking() async {
    // 1. Force ask for permission dialog every time if not granted yet
    bool hasP = await LocationService.requestPermissions();
    if (!hasP) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng cấp quyền vị trí để xem điểm trú ẩn quanh bạn.'))
        );
      }
      return;
    }

    final location = loc.Location();
    
    // Check/request permission & service (logic moved to LocationService)
    await location.changeSettings(accuracy: loc.LocationAccuracy.high);
    
    void onUpdate(loc.LocationData data) {
      if (data.latitude == null || data.longitude == null) return;
      final newLatLng = LatLng(data.latitude!, data.longitude!);
      
      if (mounted) {
        setState(() {
          _userLocation = newLatLng;
          // Only fetch FROM API once on first location, or manually
          if (!_hasFetchedInitialShelters) {
            _hasFetchedInitialShelters = true;
            _fetchShelters();
          }
        });

        // If currently in Shelter tab, keep visuals centered
        if (_selectedFilterIndex == 2) {
          _updateUserMarker(newLatLng);
          _updateRadiusVisuals(newLatLng);
          if (_mapController != null) {
            _mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: newLatLng, zoom: 10.0), // Zoom out more to see the edge
            ));
          }
        }
      }
    }

    // 2. Start listening
    _locationSubscription = location.onLocationChanged.listen(onUpdate);

    // 3. Get initial location immediately
    try {
      // Try cached first for instant response
      final cachedPos = await LocationService.getCurrentLocation();
      if (cachedPos != null) {
        onUpdate(loc.LocationData.fromMap({
          'latitude': cachedPos.lat,
          'longitude': cachedPos.lon,
        }));
      } else {
        // Fallback to fresh fetch with short timeout
        final initialData = await location.getLocation().timeout(
          const Duration(seconds: 3),
        );
        onUpdate(initialData);
      }
    } catch (_) {
      debugPrint('Initial location fetch timed out or failed, waiting for stream...');
    }
  }

  Future<void> _requestPermissions() async {
    // Permission handling logic handled in LocationService.getCurrentLocation()
    // and used by _initLocationTracking via loc.Location()
  }

  void _updateCamera(int index) {
    if (_mapController == null) return;
    
    LatLng target;
    double zoom;
    
    if (index == 0) {
      target = _userLocation ?? _hn;
      zoom = 14.0;
    } else if (index == 1) {
      target = _userLocation ?? _dn;
      zoom = 6.0;
    } else {
      // For Shelter tab (index 2)
      if (_userLocation != null) {
        target = _userLocation!;
        zoom = 10.0; // Zoom out to see the 15km circle
      } else {
        // If no user location yet, just stay or move to center
        target = _dn; 
        zoom = 5.0;
      }
    }
    
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: zoom),
    ));
  }

  void _clearRoute() {
    if (_currentRoute != null) {
      _mapController?.removeLine(_currentRoute!);
      _currentRoute = null;
    }
  }

  void _clearRadiusVisuals() {
    if (_radiusFill != null) {
      _mapController?.removeFill(_radiusFill!);
      _radiusFill = null;
    }
    if (_radiusOutline != null) {
      _mapController?.removeLine(_radiusOutline!);
      _radiusOutline = null;
    }
  }



  void _clearUserMarker() {
    if (_userMarkerCircle != null) {
      _mapController?.removeCircle(_userMarkerCircle!);
      _userMarkerCircle = null;
    }
  }

  Future<void> _updateUserMarker(LatLng center) async {
    _clearUserMarker();
    
    // Only show if we are on the Shelter tab (index 2)
    if (_selectedFilterIndex != 2) return;

    final circle = await _mapController?.addCircle(CircleOptions(
      geometry: center,
      circleColor: "#0058BE",
      circleRadius: 8.0,
      circleStrokeWidth: 3.0,
      circleStrokeColor: "#FFFFFF",
      circleOpacity: 1.0,
    ));

    setState(() {
      _userMarkerCircle = circle;
    });
  }

  Future<void> _updateRadiusVisuals(LatLng center) async {
    _clearRadiusVisuals();
    _updateUserMarker(center);
    
    // Only show if we are on the Shelter tab (index 2)
    if (_selectedFilterIndex != 2) return;

    final circlePoints = LocationService.generateCirclePoints(center.latitude, center.longitude, 15.0);
    
    // Draw Fill
    final fill = await _mapController?.addFill(FillOptions(
      geometry: circlePoints,
      fillColor: "#0058BE",
      fillOpacity: 0.08, // Reduced opacity for clarity
    ));

    // Draw Outline
    final outline = await _mapController?.addLine(LineOptions(
      geometry: circlePoints[0],
      lineColor: "#003D82", // Darker blue for contrast
      lineWidth: 3.5, // Thicker outline
      lineOpacity: 0.8, // More visible outline
    ));

    setState(() {
      _radiusFill = fill;
      _radiusOutline = outline;
    });
  }

  Future<void> _drawRoute(ShelterModel shelter) async {
    // This local drawing method is being replaced by NavigationScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchShelters,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                          _clearRoute();
                          
                          if (index == 2 && _userLocation != null) {
                            _updateRadiusVisuals(_userLocation!);
                            _updateUserMarker(_userLocation!);
                          } else {
                            _clearRadiusVisuals();
                            _clearUserMarker();
                          }
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
              initialCameraPosition: const CameraPosition(target: _dn, zoom: 6.0),
              myLocationEnabled: true,
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
            _buildMapControlButton(Icons.layers_outlined, onTap: () {
               // Cycle map layers if needed
            }),
            _buildMapControlButton(Icons.my_location, onTap: () {
               if (_userLocation != null) _updateCamera(_selectedFilterIndex);
            }),
            _buildMapControlButton(Icons.map, 
              backgroundColor: const Color(0xFF0058BE), 
              iconColor: Colors.white,
              onTap: () {
                // Return to default view
                _updateCamera(0);
              }
            ),
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

  Widget _buildMapControlButton(IconData icon, {VoidCallback? onTap, Color backgroundColor = Colors.white, Color iconColor = const Color(0xFF5A5F6B)}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0x19C2C6D6)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Điểm trú ẩn', style: TextStyle(color: Color(0xFF191C1E), fontSize: 24, fontFamily: 'Manrope', fontWeight: FontWeight.w700, letterSpacing: -0.60)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(9999)),
              child: const Text('24 điểm sẵn sàng', style: TextStyle(color: Color(0xFF166534), fontSize: 12, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Chỉ hiển thị các địa điểm trú ẩn trong bán kính 15km quanh bạn',
          style: TextStyle(color: Color(0xFF424754), fontSize: 13, fontFamily: 'Manrope', fontWeight: FontWeight.w500),
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
      children: _shelters.map((shelter) {
        double distance = 0.0;
        if (_userLocation != null) {
          distance = LocationService.calculateDistance(
            _userLocation!.latitude, _userLocation!.longitude,
            shelter.lat, shelter.lng
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showShelterDetail(shelter),
            borderRadius: BorderRadius.circular(24),
            child: _buildShelterListItem(
              shelter.name, 
              shelter.address, 
              shelter.currentPeople, 
              shelter.capacity, 
              double.parse(distance.toStringAsFixed(1))
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showShelterDetail(ShelterModel shelter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.home_work_outlined, color: Color(0xFF166534), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shelter.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF191C1E)),
                        ),
                        Text(
                          shelter.address,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF727785)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text('CÔNG SUẤT HIỆN TẠI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Color(0xFF0058BE))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${shelter.currentPeople}/${shelter.capacity} người',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF191C1E)),
                  ),
                  Text(
                    '${(shelter.currentPeople / shelter.capacity * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.w800, 
                      color: (shelter.currentPeople / shelter.capacity) > 0.9 ? Colors.red : const Color(0xFF166534)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: shelter.currentPeople / shelter.capacity,
                  minHeight: 12,
                  backgroundColor: const Color(0xFFF2F4F6),
                  color: (shelter.currentPeople / shelter.capacity) > 0.9 ? Colors.red : const Color(0xFF166534),
                ),
              ),
              const SizedBox(height: 32),
              const Text('TIỆN NGHI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Color(0xFF0058BE))),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                   if (shelter.hasCleanWater) _buildAmenityBadge(Icons.water_drop, 'Nước sạch'),
                   if (shelter.hasFood) _buildAmenityBadge(Icons.restaurant, 'Thực phẩm'),
                   if (shelter.hasFirstAid) _buildAmenityBadge(Icons.medical_services, 'Sơ cứu'),
                   if (shelter.hasPower) _buildAmenityBadge(Icons.power, 'Điện'),
                   if (shelter.hasWifi) _buildAmenityBadge(Icons.wifi, 'Wifi'),
                   if (!shelter.hasCleanWater && !shelter.hasFood && !shelter.hasFirstAid && !shelter.hasPower && !shelter.hasWifi)
                     const Text('Không có thông tin tiện nghi', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavigationScreen(shelter: shelter),
                            ),
                          );
                        },
                        icon: const Icon(Icons.directions, size: 20),
                        label: const Text('Chỉ đường', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0058BE),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Đóng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF424754))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0058BE)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF191C1E))),
        ],
      ),
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
