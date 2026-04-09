import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Use your computer's local IP address instead of 10.0.2.2 for real device testing
  // Make sure your phone and computer are on the same Wi-Fi network.
  static const String _localIp = '192.168.1.49'; // Updated to new Wi-Fi IP
  
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:5000';
    }
    
    // For real devices, we MUST use the local IP address.
    // 10.0.2.2 only works for the Android Emulator.
    if (Platform.isAndroid || Platform.isIOS) {
      return 'http://$_localIp:5000';
    }
    
    return 'http://127.0.0.1:5000';
  }

  static String get apiUrl => '$baseUrl/api';
}
