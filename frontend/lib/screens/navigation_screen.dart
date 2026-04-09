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
  bool _isLoadingRoute = true;
  double _distanceKm = 0.0;

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
          _isLoadingRoute = false;
          _distanceKm = LocationService.calculateDistance(origin.latitude, origin.longitude, destination.latitude, destination.longitude);
        });

        if (points.isNotEmpty) {
          await _mapController?.addCircle(CircleOptions(
            geometry: origin,
            circleColor: '#3B82F6',
            circleRadius: 8.0,
            circleStrokeWidth: 2.0,
            circleStrokeColor: '#FFFFFF',
          ));

          await _mapController?.addLine(LineOptions(
            geometry: points,
            lineColor: "#0058BE",
            lineWidth: 6.0,
            lineOpacity: 0.9,
          ));

          double minLat = origin.latitude < destination.latitude ? origin.latitude : destination.latitude;
          double maxLat = origin.latitude > destination.latitude ? origin.latitude : destination.latitude;
          double minLng = origin.longitude < destination.longitude ? origin.longitude : destination.longitude;
          double maxLng = origin.longitude > destination.longitude ? origin.longitude : destination.longitude;

          _mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)), left: 100, top: 200, right: 100, bottom: 200),
          );
          
          await _mapController?.addCircle(CircleOptions(
            geometry: destination,
            circleColor: '#EF4444',
            circleRadius: 10.0,
            circleStrokeWidth: 4.0,
            circleStrokeColor: '#FFFFFF',
          ));

          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Đã tính được lộ trình: ${_distanceKm.toStringAsFixed(1)} km'),
               duration: const Duration(seconds: 3),
             )
           );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingRoute = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
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
            styleString: "https://tiles.goong.io/assets/goong_map_highlight.json?api_key=jTmhSjJz211NLnmhk3nV79bvgmehQxgNhiIUGDWT",
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
            child: Container(
              padding: const EdgeInsets.all(24),
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
                        'Khoảng cách đến điểm trú ẩn',
                        style: TextStyle(color: Color(0xFF727785), fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.shelter.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF191C1E)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.shelter.address,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF727785)),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0058BE),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Kết thúc chỉ đường', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
}
