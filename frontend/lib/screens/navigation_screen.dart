import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../models/shelter_model.dart';
import '../services/directions_service.dart';
import '../services/location_service.dart';

class NavigationScreen extends StatefulWidget {
  final ShelterModel shelter;

  const NavigationScreen({super.key, required this.shelter});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  MapLibreMapController? _mapController;
  bool _isStyleLoaded = false;
  List<LatLng> _routePoints = [];
  List<RouteStep> _steps = [];
  bool _isLoadingRoute = true;
  double _distanceKm = 0.0;
  bool _showSteps = false;

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoadedCallback() async {
    setState(() => _isStyleLoaded = true);
    _calculateAndDrawRoute();
  }

  Future<void> _calculateAndDrawRoute() async {
    try {
      int retryCount = 0;
      ({double lat, double lon})? userPos;

      while (retryCount < 3 && userPos == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(retryCount == 0 ? 'Đang xác định vị trí của bạn...' : 'Đang thử định vị lại lần $retryCount...'), 
              duration: const Duration(seconds: 2)
            )
          );
        }
        
        userPos = await LocationService.getCurrentLocation();
        if (userPos == null) {
          retryCount++;
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      
      if (userPos == null) {
        if (mounted) {
          setState(() => _isLoadingRoute = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể lấy vị trí sau nhiều lần thử. Vui lòng bật GPS và cho phép trình duyệt truy cập vị trí.'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 6),
            )
          );
        }
        return;
      }

      final LatLng origin = LatLng(userPos.lat, userPos.lon);
      final LatLng destination = LatLng(widget.shelter.lat, widget.shelter.lng);
      
      // Update camera to user location once found
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(origin, 14));

      await Future.delayed(const Duration(milliseconds: 500)); // Ensure style is ready
      final res = await DirectionsService.getRoute(origin, destination);
      final List<LatLng> points = res.points;

      if (mounted) {
        if (points.isEmpty) {
           setState(() => _isLoadingRoute = false);
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Chỉ đường thất bại: ${res.status}. Vui lòng kiểm tra lại.'),
               duration: const Duration(seconds: 5),
               backgroundColor: Colors.orange,
             )
           );
           return;
        }

        setState(() {
          _routePoints = points;
          _steps = res.steps;
          _isLoadingRoute = false;
        });

        // Use the distance from API if available (via geocoding_service or similar, but here we calculate)
        _distanceKm = LocationService.calculateDistance(origin.latitude, origin.longitude, destination.latitude, destination.longitude);

        if (points.isNotEmpty) {
          debugPrint('DRAWING ROUTE WITH ${points.length} POINTS');
          
          // Clear previous (if any - though new screen usually won't have)
          await _mapController?.clearLines();
          await _mapController?.clearCircles();

          // Standard delay to ensure MapLibre is ready for draw calls
          await Future.delayed(const Duration(milliseconds: 300));

          // Draw origin
          await _mapController?.addCircle(CircleOptions(
            geometry: origin,
            circleColor: '#3B82F6',
            circleRadius: 8.0,
            circleStrokeWidth: 2.0,
            circleStrokeColor: '#FFFFFF',
          ));

          // Draw polyline
          await _mapController?.addLine(LineOptions(
            geometry: points,
            lineColor: "#0058BE",
            lineWidth: 6.0,
            lineOpacity: 0.9,
            lineJoin: "round",
          ));

          // Draw destination
          await _mapController?.addCircle(CircleOptions(
            geometry: destination,
            circleColor: '#EF4444',
            circleRadius: 10.0,
            circleStrokeWidth: 4.0,
            circleStrokeColor: '#FFFFFF',
          ));

          // Set bounds to fit route
          double minLat = origin.latitude < destination.latitude ? origin.latitude : destination.latitude;
          double maxLat = origin.latitude > destination.latitude ? origin.latitude : destination.latitude;
          double minLng = origin.longitude < destination.longitude ? origin.longitude : destination.longitude;
          double maxLng = origin.longitude > destination.longitude ? origin.longitude : destination.longitude;

          // Inflate bounds a bit with polyline points
          for (var p in points) {
            if (p.latitude < minLat) minLat = p.latitude;
            if (p.latitude > maxLat) maxLat = p.latitude;
            if (p.longitude < minLng) minLng = p.longitude;
            if (p.longitude > maxLng) maxLng = p.longitude;
          }

          _mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)), 
              left: 50, top: 150, right: 50, bottom: 250
            ),
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã tìm thấy lộ trình: ${_distanceKm.toStringAsFixed(1)} km'),
                duration: const Duration(seconds: 3),
              )
            );
          }
        } else {
           debugPrint('ROUTE POINTS ARE EMPTY');
        }
      }
    } catch (e) {
      debugPrint('Navigation Rendering Error: $e');
      if (mounted) {
        setState(() => _isLoadingRoute = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi hiển thị: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FULL SCREEN MAP
          MapLibreMap(
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            styleString: "https://tiles.goong.io/assets/navigation_day.json?api_key=ZcFrRowz4bVq1wtlIWDvEikppTbC863E1oqcAycg",
            initialCameraPosition: CameraPosition(target: LatLng(widget.shelter.lat, widget.shelter.lng), zoom: 14.0),
            myLocationEnabled: true,
            trackCameraPosition: true,
          ),

          // TOP BACK BUTTON
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF191C1E)),
              ),
            ),
          ),

          // BOTTOM INFO PANEL
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(24),
              constraints: BoxConstraints(
                maxHeight: _showSteps ? MediaQuery.of(context).size.height * 0.5 : 400,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_distanceKm.toStringAsFixed(1)} km',
                          style: const TextStyle(color: Color(0xFF0369A1), fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Khoảng cách',
                        style: TextStyle(color: Color(0xFF727785), fontSize: 13),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => setState(() => _showSteps = !_showSteps),
                        icon: Icon(_showSteps ? Icons.keyboard_arrow_down : Icons.list, color: const Color(0xFF0058BE)),
                      ),
                      IconButton(
                        onPressed: _calculateAndDrawRoute,
                        icon: const Icon(Icons.my_location, color: Color(0xFF0058BE)),
                        tooltip: 'Cập nhật lại vị trí',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.shelter.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF191C1E)),
                  ),
                  const SizedBox(height: 4),
                  if (!_showSteps)
                    Text(
                      widget.shelter.address,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF727785)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  if (_showSteps) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _steps.length,
                        itemBuilder: (context, index) {
                          final step = _steps[index];
                          // Simple HTML tag removal
                          final cleanLabel = step.instruction.replaceAll(RegExp(r'<[^>]*>'), '');
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _getManeuverIcon(step.maneuver),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cleanLabel,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF191C1E)),
                                      ),
                                      if (step.distance.isNotEmpty)
                                        Text(
                                          step.distance,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF727785)),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showSteps ? const Color(0xFFF1F5F9) : const Color(0xFF0058BE),
                        foregroundColor: _showSteps ? const Color(0xFF475569) : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(_showSteps ? 'Đóng chi tiết' : 'Kết thúc chỉ đường', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LOADING OVERLAY
          if (_isLoadingRoute)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }
  Widget _getManeuverIcon(String maneuver) {
    IconData iconData;
    switch (maneuver.toLowerCase()) {
      case 'left':
      case 'turn-left':
        iconData = Icons.turn_left;
        break;
      case 'right':
      case 'turn-right':
        iconData = Icons.turn_right;
        break;
      case 'slight-left':
        iconData = Icons.turn_slight_left;
        break;
      case 'slight-right':
        iconData = Icons.turn_slight_right;
        break;
      case 'straight':
        iconData = Icons.straight;
        break;
      case 'u-turn':
        iconData = Icons.u_turn_left;
        break;
      default:
        iconData = Icons.navigation;
    }
    return Icon(iconData, color: const Color(0xFF0058BE), size: 20);
  }
}

