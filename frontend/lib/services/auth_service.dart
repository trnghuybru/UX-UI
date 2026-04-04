import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // Use 10.0.2.2 for Android emulator to access computer localhost, 127.0.0.1 for iOS
  static final String baseUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:5000/api' 
      : 'http://127.0.0.1:5000/api';

  Future<AuthResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        // Handle other status codes if needed
        print('Login failed: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }
}
