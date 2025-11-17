import 'package:flutter/material.dart';
import 'package:betweener_app/models/user.dart';
import '../repository/auth_repository.dart';
import '../core/helpers/api_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  ApiResponse<User>? _userResponse;
  ApiResponse<User>? get userResponse => _userResponse;

  Future<void> login(String email, String password) async {
    _userResponse = ApiResponse.loading("Logging in...");
    notifyListeners();

    try {
      final user = await _authRepository.login(email: email, password: password);
      if (user != null) {
        _userResponse = ApiResponse.completed(user);
      } else {
        _userResponse = ApiResponse.error("Login failed. Please check credentials.");
      }
    } catch (e) {
      _userResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }


  Future<void> register(UserClass userClass) async {
    _userResponse = ApiResponse.loading("Registering user...");
    notifyListeners();

    try {
      final user = await _authRepository.register(userClass);
      if (user != null) {
        _userResponse = ApiResponse.completed(user);
      } else {
        _userResponse = ApiResponse.error("Registration failed. Try again.");
      }
    } catch (e) {
      _userResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

    Future<void> logout() async {
    await _authRepository.logout();
    _userResponse = null;
    notifyListeners();
  }
}
