import 'package:flutter/cupertino.dart';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../misc/scope.dart';

class SearchingController extends ChangeNotifier{

  SearchHandler searchHandler = SearchHandler();
  
  late List<List<dynamic>> _searchResults;

  SearchingController(){
    initialize();
  }

  Future<void> initialize() async {
    _searchResults = await searchHandler.searchItem("", Scope.student);
    notifyListeners();
  }

  Future<List<List<dynamic>>> getSearchResults() async{
    return _searchResults;
  }

  void searchResult(Future<List<List<dynamic>>> value) async{
    _searchResults = await value;

    print("printing from search_controller $_searchResults");
    notifyListeners();
  }


}