import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/requester.dart';

class AuthService {
  final Requester _requester = Requester();
  static const String _tokenKey = 'auth_token';

  Future<String> login(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };

    final response = await _requester.post('/auth/login', body: body);

    if (response is Map && response['token'] is String) {
      final token = response['token'] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);

      return token;
    }

    throw RequestException('Token não encontrado na resposta do servidor.');
  }

  Future<void> forgotPassword(String email) async {
    final body = {
      'email': email,
    };
    await _requester.post('/auth/forgot-password', body: body);
  }

  Future<void> resetPassword(String token, String newPassword) async {
    final body = {
      'token': token,
      'newPassword': newPassword,
    };
    await _requester.post('/auth/reset-password', body: body);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        await logout();
        return false;
      }
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded);
      final exp = map['exp'];
      if (exp is int) {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (DateTime.now().isAfter(expiryDate)) {
          await logout();
          return false;
        }
      }
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded);
      return map['id'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<String?> getCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded);
      return map['name'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> getCurrentUserRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return [];
    try {
      final parts = token.split('.');
      if (parts.length != 3) return [];
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded);
      final roles = map['roles'];
      if (roles is List) {
        return roles.map((r) => r.toString()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> isCurrentUserAdmin() async {
    final roles = await getCurrentUserRoles();
    return roles.contains('Administrador');
  }
}