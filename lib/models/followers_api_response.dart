import 'package:betweener_app/models/user.dart';

class FollowersResponse {
  late int followingCount;
  late int followersCount;
  late List<UserClass> following;
  late List<UserClass> followers;

  FollowersResponse();

  factory FollowersResponse.fromJson(Map<String, dynamic> json) {
    FollowersResponse resp = FollowersResponse();
    resp.followingCount = json['following_count'] ?? 0;
    resp.followersCount = json['followers_count'] ?? 0;

    resp.following = (json['following'] as List?)
        ?.map((e) => UserClass.fromJson(e))
        .toList() ??
        [];
    resp.followers = (json['followers'] as List?)
        ?.map((e) => UserClass.fromJson(e))
        .toList() ??
        [];

    return resp;
  }
}
