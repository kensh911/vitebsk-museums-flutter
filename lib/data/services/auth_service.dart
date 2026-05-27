import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyEmail = 'auth_email';
  static const _keyToken = 'auth_token';
  static const _keyUserEmail = 'user_email';
  static const _keyUserHash = 'user_password_hash';
  static const _demoEmail = 'demo@museum.by';
  static const _demoPassword = 'password123';

  final SharedPreferences _prefs;
  AuthService(this._prefs);

  bool get isLoggedIn {
    final email = _prefs.getString(_keyEmail);
    final token = _prefs.getString(_keyToken);
    return email != null && token != null;
  }

  String? get currentEmail => _prefs.getString(_keyEmail);

  Future<bool> login(String email, String password) async {
    try {
      if (email == _demoEmail && password == _demoPassword) {
        await _saveSession(email, 'demo_token');
        return true;
      }
      final storedEmail = _prefs.getString(_keyUserEmail);
      final storedHash = _prefs.getString(_keyUserHash);
      if (storedEmail == email && storedHash == _hash(password)) {
        await _saveSession(email, 'user_token');
        return true;
      }
      return false;
    } catch (e) {
      print('AuthService: login error — $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyToken);
  }

  Future<void> _saveSession(String email, String token) async {
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyToken, token);
  }

  String _hash(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}