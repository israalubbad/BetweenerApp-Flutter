import 'package:flutter/material.dart';
import '../core/helpers/api_response.dart';
import '../models/followers_api_response.dart';
import '../repository/followers_repository.dart';
class FollowersProvider extends ChangeNotifier {
  final FollowersRepository _repo = FollowersRepository();

  ApiResponse<FollowersResponse>? followersResponse;
  FollowersResponse? data;

  Set<int> followingList = {};

  Future<void> fetchFollowers() async {
    followersResponse = ApiResponse.loading('Loading...');
    notifyListeners();

    try {
      data = await _repo.fetchFollowers();

      followingList = data!.following.map((follow) => follow.id).toSet();

      followersResponse = ApiResponse.completed(data);
    } catch (e) {
      followersResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> addFollow(String followeeId) async {
    final int id = int.parse(followeeId);

    followingList.add(id);

    notifyListeners();
    try {
      await _repo.addFollowers(followeeId);
      await fetchFollowers();
    } catch (e) {
      followersResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  bool isFollowing(int userId) {
    return followingList.contains(userId);
  }
}
