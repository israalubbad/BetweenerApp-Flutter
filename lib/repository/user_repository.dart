import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/helpers/api_base_helper.dart';
import '../core/helpers/api_response.dart';
import '../core/helpers/shared_prefs.dart';
import '../core/helpers/token_helper.dart';
import '../core/util/constants.dart';
import '../models/user.dart';

class UserRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  /// get user in SharedPreferences
  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      String? userString =  SharedPrefsHelper().getValueFor('user');
      print(userString);
      if (userString == null) {
        return ApiResponse.error("User not found");
      }
      User user = userFromJson(userString);
      return ApiResponse.completed(user);

    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Search user by name
  Future<List<UserClass>> searchUser(String name) async {
    final response = await _helper.post(searchUrl, {'name': name}, headers);

    final List users = response["user"] ?? [];

    return users.map((u) => UserClass.fromJson(u)).toList();
  }

  ///  Update user Location in API + SharedPreferences
  Future<User?> updateUserLocation({required double lat , required double long }) async {
    String? userString =  SharedPrefsHelper().getValueFor('user');

    if (userString == null) return null;
    User current = userFromJson(userString);

    final url = locationUrl.replaceFirst('{id}', current.user.id.toString());

    final response = await _helper.put(
      url,
      {
        "lat": lat.toString(),
        "long": long.toString(),
      },
      headers,
    );

    current.user.lat = response["user"]["lat"];
    current.user.long = response["user"]["long"];
    SharedPrefsHelper().setData('user', userToJson(current));

    return current;
  }
}
