import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tasksync/models/user_model.dart';

class AuthStorage {
  static const _secureStorage = FlutterSecureStorage();

  /// Save login data
  static Future<void> saveLoginData({
    required UserModel loginData,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Save non-sensitive data
    prefs.setString('userId', loginData.id ?? '');
    prefs.setString('name', loginData.name ?? '');
    prefs.setString('email', loginData.email ?? '');
    prefs.setBool('isVerified', loginData.isVerified ?? false);

    // Save token securely
    await _secureStorage.write(key: 'authToken', value: token);
  }

  /// Get token securely
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'authToken');
  }

  /// Get user info from SharedPreferences
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
    };
  }

  /// Check login status
  static Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'authToken');
    return token != null && token.isNotEmpty;
  }

  /// Logout - clear everything
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _secureStorage.delete(key: 'authToken');
  }
}
