import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<String> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(email, password);
  }

  Future<bool> isLoggedIn() async {
    return await _authService.isAuthenticated();
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> forgotPassword(String email) async {
    await _authService.forgotPassword(email);
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _authService.resetPassword(token, newPassword);
  }
}