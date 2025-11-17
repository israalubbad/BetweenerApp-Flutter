import 'package:betweener_app/core/helpers/api_base_helper.dart';
import 'package:betweener_app/models/link_response_model.dart';

import '../core/helpers/token_helper.dart';
import '../core/util/constants.dart';

class LinkRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  /// Fetch all links
  Future<List<LinkElement>> fetchLinkList() async {
    final response = await _helper.get(allLinksurl, headers);
    final List<dynamic> linksJson = response['links'];
    return linksJson.map((json) => LinkElement.fromJson(json)).toList();
  }

  /// Add a new link
  Future<bool> addLink(LinkElement link) async {
    final response = await _helper.post(allLinksurl, {
      'title': link.title,
      'link': link.link,
    }, headers);

    return response.containsKey('link');
  }

  /// Update link
  Future<bool> updateLink(LinkElement link) async {
    final response = await _helper.put(
      idLinksUrl.replaceFirst('{id}', link.id.toString()),
      {'title': link.title, 'link': link.link},
      headers,
    );
    if (response['message'] == 'updated successfully') {
      return true;
    }
    return false;
  }

  /// Delete link
  Future<bool> deleteLink(int id) async {
    final response = await _helper.delete(
      idLinksUrl.replaceFirst('{id}', id.toString()),
      headers,
    );
    if (response['message'] == 'deleted successfully') {
      return true;
    }
    return false;
  }
}
