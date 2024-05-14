import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/service.dart';
import '../models/user.dart';
import 'i_user_storage.dart';

class LocalUserStorage implements IUserStorage {
  final FlutterSecureStorage _localStorage = const FlutterSecureStorage();
  static const String _currentUserKey = 'currentUser';

  String _getLocalKey(String email) => 'user_$email';

  Future<void> _saveToLocal(User user) async {
    String key = _getLocalKey(user.email);
    String value = jsonEncode(user.toMap());
    await _localStorage.write(key: key, value: value);
  }

  Future<User?> _getFromLocal(String email) async {
    String key = _getLocalKey(email);
    String? userData = await _localStorage.read(key: key);
    if (userData == null) return null;

    Map<String, dynamic> userMap = jsonDecode(userData);
    return User.fromMap(userMap);
  }

  @override
  Future<void> saveUser(User user) async {
    await _saveToLocal(user);
  }

  @override
  Future<User?> getUser(String email) async {
    return await _getFromLocal(email);
  }

  @override
  Future<void> clearUser(String email) async {
    String key = _getLocalKey(email);
    await _localStorage.delete(key: key);
    if (email == await _localStorage.read(key: _currentUserKey)) {
      await _localStorage.delete(key: _currentUserKey);
    }
  }

  @override
  Future<void> saveCurrentUser(String email) async {
    await _localStorage.write(key: _currentUserKey, value: email);
  }

  @override
  Future<void> clearCurrentUser() async {
    await _localStorage.delete(key: _currentUserKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    String? email = await _localStorage.read(key: _currentUserKey);
    if (email != null) {
      return await _getFromLocal(email);
    }
    return null;
  }

  Future<void> createService(ServiceBarb service) async {
    String? email = await _localStorage.read(key: _currentUserKey);
    var user = await _getFromLocal(email!);
    user?.addService(service);
    await _saveToLocal(user!);
  }

  Future<List<dynamic>> getUserServices(String email) async {
    try {
      String key = _getLocalKey(email);
      String? userData = await _localStorage.read(key: key);
      if (userData == null) return [];

      Map<String, dynamic> userMap = jsonDecode(userData);
      User user = User.fromMap(userMap);
      return user.selectedServices;
    } catch (e) {
      print('Error getting user services from local storage: $e');
    }

    return [];
  }

  Future<void> deleteService(int serviceId) async {
    String? email = await _localStorage.read(key: _currentUserKey);
    var user = await _getFromLocal(email!);
    if (user != null) {
      user.selectedServices.removeWhere((service) => service.id == serviceId);
      await _saveToLocal(user);
    }
  }
}
