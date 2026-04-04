import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/shelter_model.dart';

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
}
