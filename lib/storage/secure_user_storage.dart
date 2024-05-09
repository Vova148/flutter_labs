import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import 'i_user_storage.dart';

class SecureUserStorage implements IUserStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();


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
  }

  @override
  Future<List<User>> getAllUsers() async {
    List<User> users = [];
    Map<String, String> allEntries = await _storage.readAll();
    for (var entry in allEntries.entries) {
      if (entry.key.startsWith('user_')) {
        Map<String, dynamic> userMap = jsonDecode(entry.value);
        users.add(User.fromMap(userMap));
      }
    }
    return users;
  }
}