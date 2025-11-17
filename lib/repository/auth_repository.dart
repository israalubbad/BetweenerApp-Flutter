import 'dart:convert';

import 'package:betweener_app/models/user.dart';
import 'package:betweener_app/core/util/constants.dart';
import 'package:betweener_app/core/helpers/shared_prefs.dart';

import '../core/helpers/api_base_helper.dart';

class AuthRepository {
  final SharedPrefsHelper _prefs = SharedPrefsHelper();
  final ApiBaseHelper _apiHelper = ApiBaseHelper();

  /// Login  user
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final responseJson = await _apiHelper.post(
        loginURL,
        {'email': email,
          'password': password},
        {'Accept': 'application/json'},
      );

      final user = User.fromJson(responseJson);
      _prefs.setData('user', jsonEncode(user.toJson()));
      print(user.token);

      if (user.token != null) {
         _prefs.setData('token', user.token);
      }

      return user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// Register user
  Future<User?> register(UserClass user) async {
    try {
      final responseJson = await _apiHelper.post(
        registerURL,
        {
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'password_confirmation': user.confirmationPassword,
        },
        {'Accept': 'application/json'},
      );

      final newUser = User.fromJson(responseJson);

       _prefs.setData('user', newUser);
         print(newUser.token);

      if (newUser.token != null) {
         _prefs.setData('token', newUser.token);
      }

      return newUser;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('token');
    await _prefs.remove('user');
  }

}
