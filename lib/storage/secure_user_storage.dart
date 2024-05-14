import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import 'i_user_storage.dart';

class SecureUserStorage implements IUserStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _currentUserKey = 'currentUser';

  String _getKey(String email) => 'user_$email';

  @override
  Future<void> saveUser(User user) async {

    String key = _getKey(user.email);
    String value = jsonEncode(user.toMap());
    await _storage.write(key: key, value: value);
  }

  @override
  Future<User?> getUser(String email) async {
    String key = _getKey(email);
    String? userData = await _storage.read(key: key);
    if (userData == null) return null;

    // Перетворення з JSON рядка на Map
    Map<String, dynamic> userMap = jsonDecode(userData);

    // Створення об'єкта User із Map
    return User.fromMap(userMap);
  }

  @override
  Future<void> clearUser(String email) async {
    String key = _getKey(email);
    await _storage.delete(key: key);
    if (email == await _storage.read(key: _currentUserKey)) {
      await _storage.delete(key: _currentUserKey);
    }
  }


  Future<void> saveCurrentUser(String email) async {
    await _storage.write(key: _currentUserKey, value: email);
  }

  // Clear the current user's information
  Future<void> clearCurrentUser() async {
    await _storage.delete(key: _currentUserKey);
  }

  // Retrieve the current user automatically on app start
  Future<User?> getCurrentUser() async {
    String? email = await _storage.read(key: _currentUserKey);
    if (email != null) {
      return await getUser(email);
    }
    return null;
  }

  @override
  Future<List<dynamic>> getUserServices(String email) async {
    String key = _getKey(email);
    String? userData = await _storage.read(key: key);
    if (userData != null) {
      Map<String, dynamic> userMap = jsonDecode(userData);
      List<dynamic> selectedServices = userMap['selectedServices'] ?? [];
      return selectedServices;
    }
    return [];
  }

}