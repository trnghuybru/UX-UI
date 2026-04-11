import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ContactModel {
  final int id;
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
    required this.isPrimary,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      relationship: json['relationship'] ?? '',
      isPrimary: json['is_primary'] ?? false,
    );
  }
}

class ContactService {
  Future<List<ContactModel>> fetchContacts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/emergency-contacts'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ContactModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching contacts: $e');
      return [];
    }
  }

  Future<bool> addContact({
    required String name,
    required String phone,
    required String relationship,
    required bool isPrimary,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/emergency-contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'phone': phone,
          'relationship': relationship,
          'is_primary': isPrimary,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error adding contact: $e');
      return false;
    }
  }

  Future<bool> updateContact({
    required int id,
    required String name,
    required String phone,
    required String relationship,
    required bool isPrimary,
    required String token,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/emergency-contacts/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'phone': phone,
          'relationship': relationship,
          'is_primary': isPrimary,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating contact: $e');
      return false;
    }
  }

  Future<bool> deleteContact(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/emergency-contacts/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting contact: $e');
      return false;
    }
  }
}
