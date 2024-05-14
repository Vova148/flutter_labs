import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service.dart';
import '../models/user.dart';
import 'i_user_storage.dart';

class APIUserStorage implements IUserStorage {
  final String baseUrl;

  APIUserStorage(this.baseUrl);

  @override
  Future<void> saveUser(User user) async {
    final url = Uri.parse('$baseUrl/users/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toMap()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to save user');
      }
    } catch (e) {
      print('Error saving user to server: $e');
    }
  }

  @override
  Future<User?> getUser(String email) async {
    final url = Uri.parse('$baseUrl/users/$email');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromMap(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get user');
      }
    } catch (e) {
      print('Error getting user from server: $e');
    }
    return null;
  }

  @override
  Future<void> clearUser(String email) async {
    final url = Uri.parse('$baseUrl/users/$email');
    try {
      final response = await http.delete(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user from server: $e');
    }
  }

  @override
  Future<void> saveCurrentUser(String email) async {
    // API частина не зберігає поточного користувача локально
  }

  @override
  Future<void> clearCurrentUser() async {
    // API частина не очищує поточного користувача локально
  }

  @override
  Future<User?> getCurrentUser() async {
    // API частина не отримує поточного користувача локально
    return null;
  }

  Future<void> createService(ServiceBarb service) async {
    final url = Uri.parse('$baseUrl/servicebars/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(service.toMap()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create service');
      }
    } catch (e) {
      print('Error creating service: $e');
    }
  }

  Future<List<dynamic>> getUserServices(String email) async {
    final url = Uri.parse('$baseUrl/users/$email/services');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<ServiceBarb> res = [];
        for (var s in data) {
          res.add(ServiceBarb.fromMap(s));
        }
        return res;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to get user services');
      }
    } catch (e) {
      print('Error getting user services from server: $e');
    }
    return [];
  }

  Future<void> deleteService(int serviceId) async {
    final url = Uri.parse('$baseUrl/servicebars/$serviceId');
    try {
      final response = await http.delete(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200) {
        throw Exception('Failed to delete service');
      }
    } catch (e) {
      print('Error deleting service: $e');
    }
  }
}
