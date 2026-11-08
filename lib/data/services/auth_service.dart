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
    return token != null && token.isNotEmpty;
  }
}