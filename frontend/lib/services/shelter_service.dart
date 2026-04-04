import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/shelter_model.dart';
import 'user_session.dart';

class ShelterService {
  // Use 10.0.2.2 for Android emulator, 127.0.0.1 for iOS/Desktop
  static final String baseUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:5000/api' 
      : 'http://127.0.0.1:5000/api';

  Future<List<ShelterModel>> fetchShelters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/shelters'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List items = data['items'] ?? [];
        return items.map((json) => ShelterModel.fromJson(json)).toList();
      } else {
        print('Failed to load shelters: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Shelter Service Error: $e');
      return [];
    }
  }

  Future<List<ShelterModel>> fetchMyShelters() async {
    try {
      final String? token = UserSession().accessToken;
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/shelters/my-shelters'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List items = data['items'] ?? [];
        return items.map((json) => ShelterModel.fromJson(json)).toList();
      } else {
        print('Failed to load my shelters: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('My Shelter Service Error: $e');
      return [];
    }
  }

  Future<bool> updateShelter(ShelterModel shelter) async {
    try {
      final String? token = UserSession().accessToken;
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/shelters/${shelter.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(shelter.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update Shelter Error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> registerShelter(Map<String, dynamic> shelterData) async {
    try {
      final String? token = UserSession().accessToken;
      if (token == null) return {'success': false, 'message': 'Phiên làm việc hết hạn'};

      final response = await http.post(
        Uri.parse('$baseUrl/shelters'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(shelterData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'message': 'Thành công'};
      } else {
        String errorMsg = 'Lỗi server (${response.statusCode})';
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) errorMsg = data['message'];
        } catch (_) {}
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Kết nối thất bại: $e'};
    }
  }
}
