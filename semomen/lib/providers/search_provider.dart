import 'package:flutter/foundation.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/post_model.dart';

class SearchProvider extends ChangeNotifier {
  List<PostModel> _searchResults = [];
  List<PostModel> get searchResults => _searchResults;

  void resetResults() {
    _searchResults = [];
    notifyListeners();
  }


  Future<List<PostModel>> getSearchResult({required String category, required String searchText}) async {
    final postCollection = await postRef.get();

    if(category == 'title') {
      final results = postCollection.docs.where((element) => element.get('intro_title').toString().contains(searchText)).toList();
      _searchResults = results.map((e) => PostModel.fromDoc(e)).toList();
    } else if(category == 'mentor') {

      final results = postCollection.docs.where((element) => element.get('user_name').toString().contains(searchText)).toList();
      _searchResults = results.map((e) => PostModel.fromDoc(e)).toList();
    } else {

      final results = postCollection.docs.where((element) => element.get('job').toString().contains(searchText)).toList();
      _searchResults = results.map((e) => PostModel.fromDoc(e)).toList();
    }

    notifyListeners();
    return _searchResults;
  }

}