import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class SosRequestModel {
  final int id;
  final String phoneNumber;
  final String? type;
  final String? description;
  final double? lat;
  final double? lng;
  final String status;
  final DateTime createdAt;

  SosRequestModel({
    required this.id,
    required this.phoneNumber,
    this.type,
    this.description,
    this.lat,
    this.lng,
    required this.status,
    required this.createdAt,
  });

  factory SosRequestModel.fromJson(Map<String, dynamic> json) {
    return SosRequestModel(
      id: json['id'],
      phoneNumber: json['phone_number'] ?? 'Không rõ',
      type: json['type'],
      description: json['description'],
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lng: json['lng'] != null ? (json['lng'] as num).toDouble() : null,
      status: json['status'] ?? 'PENDING',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
class SosService {
  Future<bool> createSos({
    required String phone,
    required double lat,
    required double lng,
    String? description,
    int? peopleCount,
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/sos-requests'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'phone': phone,
          'lat': lat,
          'lng': lng,
          'description': description,
          'people_count': peopleCount,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating SOS: $e');
      return false;
    }
  }

  Future<List<SosRequestModel>> fetchAllSosRequests() async {
    try {
      // Need a way to fetch all SOS requests. 
      // I'll assume the backend has /api/sos-requests (GET) for all requests (admin/rescuer)
      // or /api/sos-requests/mine for current user.
      // For "tổng hợp", we probably want all of them.
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/sos-requests'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['items'];
        return data.map((item) => SosRequestModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching SOS requests: $e');
      return [];
    }
  }
}
