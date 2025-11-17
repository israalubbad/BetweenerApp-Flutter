import 'package:flutter/material.dart';
import '../core/helpers/api_response.dart';
import '../models/link_response_model.dart';
import '../repository/link_repository.dart';

class LinkProvider with ChangeNotifier {
  final LinkRepository _repository = LinkRepository();
  ApiResponse<List<LinkElement>> links = ApiResponse.loading();
  ApiResponse<bool> addStatus = ApiResponse.completed(false);
  ApiResponse<bool> updateStatus = ApiResponse.completed(false);
  ApiResponse<bool> deleteStatus = ApiResponse.completed(false);

  Future<void> fetchLinks() async {
    links = ApiResponse.loading("Fetching links...");
    notifyListeners();

    try {
      final linkList = await _repository.fetchLinkList();
      links = ApiResponse.completed(linkList);
    } catch (e) {
      links = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> addLink(LinkElement link) async {
    addStatus = ApiResponse.loading("Adding link...");
    notifyListeners();

    try {
      final success = await _repository.addLink(link);
      addStatus = ApiResponse.completed(success);

      if (success) {
        links.data ??= [];
        links.data!.add(link);
        notifyListeners();
      }
    } catch (e) {
      addStatus = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  Future<void> updateLink(LinkElement link) async {
    updateStatus = ApiResponse.loading("Updating link...");
    notifyListeners();

    try {
      final success = await _repository.updateLink(link);
      updateStatus = ApiResponse.completed(success);

      if (success && links.data != null) {
        final index = links.data!.indexWhere((element) => element.id == link.id);
        if (index != -1) {
          links.data![index] = link;
          notifyListeners();
        }
      }
    } catch (e) {
      updateStatus = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }


  Future<void> deleteLink(int id) async {
    deleteStatus = ApiResponse.loading("Deleting link...");
    notifyListeners();

    try {
      final success = await _repository.deleteLink(id);
      deleteStatus = ApiResponse.completed(success);

      if (success && links.data != null) {
        links.data!.removeWhere((element) => element.id == id);
        notifyListeners();
      }
    } catch (e) {
      deleteStatus = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
