import 'package:flutter/material.dart';
import '../core/helpers/api_response.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();

  ApiResponse<User>? _userResponse;
  ApiResponse<User>? get userResponse => _userResponse;

  ApiResponse<List<UserClass>> users = ApiResponse.loading();

  Future<void> loadUser() async {
    _userResponse = ApiResponse.loading("Loading user...");
    notifyListeners();

    final response = await _repository.getCurrentUser();
    _userResponse = response;

    notifyListeners();
  }

  Future<void> searchUser(String name) async {
    users = ApiResponse.loading("Searching...");
    notifyListeners();

    try {
      final response = await _repository.searchUser(name);
      users = ApiResponse.completed(response);
    } catch (e) {
      users = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> updateLocation(double lat, double long) async {
    _userResponse = ApiResponse.loading("Updating location...");
    notifyListeners();

    final updatedUser =
    await _repository.updateUserLocation(lat: lat, long: long);

    if (updatedUser != null) {
      _userResponse = ApiResponse.completed(updatedUser);
    } else {
      _userResponse = ApiResponse.error("Failed to update location");
    }

    notifyListeners();
  }
}
