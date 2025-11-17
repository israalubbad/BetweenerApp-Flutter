
import '../core/helpers/api_base_helper.dart';
import '../core/helpers/token_helper.dart';
import '../core/util/constants.dart';
import '../models/followers_api_response.dart';


class FollowersRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  /// Fetch all Followers
  Future<FollowersResponse> fetchFollowers() async {
    final response = await _helper.get(followUrl, headers);
    return FollowersResponse.fromJson(response);
  }

  /// Add a Follower
  Future<FollowersResponse?> addFollowers(String followeeId) async {
    final response = await _helper.post(followUrl,  {'followee_id': followeeId}, headers);

    if (response['followee']) {
      return response['followee'] ;
    } else {
      return null;
    }

  }



}
