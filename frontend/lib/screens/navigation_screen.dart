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
      // 1. Get current location
      final userPos = await LocationService.getCurrentLocation();
      final LatLng origin = LatLng(userPos.lat, userPos.lon);
      final LatLng destination = LatLng(widget.shelter.lat, widget.shelter.lng);

      // 2. Fetch route from service
      final List<LatLng> points = await DirectionsService.getRoute(origin, destination);

      if (mounted) {
        setState(() {
          _routePoints = points;
          _isLoadingRoute = false;
          _distanceKm = LocationService.calculateDistance(
            origin.latitude, origin.longitude, 
            destination.latitude, destination.longitude
          );
        });

        if (points.isNotEmpty) {
          // 3. Draw on map
          await _mapController?.addLine(LineOptions(
            geometry: points,
            lineColor: "#0058BE",
            lineWidth: 6.0,
            lineOpacity: 0.9,
          ));

          // 4. Zoom to fit
          double minLat = origin.latitude < destination.latitude ? origin.latitude : destination.latitude;
          double maxLat = origin.latitude > destination.latitude ? origin.latitude : destination.latitude;
          double minLng = origin.longitude < destination.longitude ? origin.longitude : destination.longitude;
          double maxLng = origin.longitude > destination.longitude ? origin.longitude : destination.longitude;

          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          );

          _mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, left: 80, top: 150, right: 80, bottom: 150),
          );
          
          // Add marker for destination
          await _mapController?.addSymbol(SymbolOptions(
            geometry: destination,
            iconImage: "marker-15",
            textField: widget.shelter.name,
            textOffset: const Offset(0, 2),
            textColor: '#B90538',
            textSize: 14.0,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingRoute = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi hướng dẫn: $e')),
        );
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
