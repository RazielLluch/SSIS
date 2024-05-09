import 'package:flutter/cupertino.dart';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../misc/scope.dart';

class SearchingController extends ChangeNotifier{

  SearchHandler searchHandler = SearchHandler();
  
  late Future<List<List<dynamic>>> _searchResults = searchHandler.searchItem("", Scope.student);

  Future<List<List<dynamic>>> getSearchResults(){
    return _searchResults;
  }

  void searchResult(Future<List<List<dynamic>>> value){
    _searchResults = value;

    print("printing from search_controller $_searchResults");
    notifyListeners();
  }


}