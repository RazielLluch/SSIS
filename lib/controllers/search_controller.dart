import 'package:flutter/cupertino.dart';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../misc/scope.dart';

class SearchingController extends ChangeNotifier{

  SearchHandler searchHandler = SearchHandler();
  
  late List<List<dynamic>> _studentSearchResults;
  late List<List<dynamic>> _courseSearchResults;

  SearchingController(){
    initialize();
  }

  void initialize() async {
    _studentSearchResults = await searchHandler.searchItem("", Scope.student);
    print("notifying students");
    notifyListeners();
    _courseSearchResults = await searchHandler.searchItem("", Scope.course);
    print("notifying courses");
    notifyListeners();
  }

  Future<List<List<dynamic>>> getSearchResults(Scope scope) async{
    if(scope == Scope.student) {
      return _studentSearchResults;
    } else {
      return _courseSearchResults;
    }
  }

  Future<void> searchResult(Future<List<List<dynamic>>> value, Scope scope) async{

    if(scope == Scope.student){
      _studentSearchResults = await value;
    }else{
      _courseSearchResults = await value;
    }

    print("printing from search_controller $value");
    notifyListeners();
  }


}