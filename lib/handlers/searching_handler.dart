import 'package:new_ssis_2/misc/scope.dart';
import 'package:new_ssis_2/repository/course_repo.dart';
import 'package:new_ssis_2/repository/student_repo.dart';

class SearchHandler{
  SearchHandler();

  Future<List<List<dynamic>>> searchItem(var query, Scope scope)async{

    List<List> validSearches = [];
    List<List> rawSearches;
    if(scope == Scope.course){
      CourseRepo cRepo = CourseRepo();
      rawSearches = await cRepo.getList();
    } else{
      StudentRepo sRepo = StudentRepo();
      rawSearches = await sRepo.getList();
    }

    // print('raw searches: $rawSearches');

    for(int i = 1; i < rawSearches.length; i++){
      List temp = rawSearches[i];
      for(var val in temp){
        if(val.toString().toLowerCase().trim().contains(query.toLowerCase())){
          validSearches.add(temp);
          break;
        }
      }
    }

    // print('valid searches: $validSearches');

    print(validSearches);
    return validSearches;
  }

  Future<List<int>> searchItemIndexes(var query, Scope scope) async{
    List<int> validSearches = [];
    List<List> rawSearches;
    if(scope == Scope.course){
      CourseRepo cRepo = CourseRepo();
      rawSearches = await cRepo.getList();
    } else{
      StudentRepo sRepo = StudentRepo();
      rawSearches = await sRepo.getList();
    }

    // print('raw searches: $rawSearches');

    for(int i = 1; i < rawSearches.length; i++){
      List temp = rawSearches[i];
      for(var val in temp){
        if(val.toString().toLowerCase().trim().contains(query.toLowerCase())){
          validSearches.add(i);
          break;
        }
      }
    }

    // print('valid searches: $validSearches');

    print(validSearches);
    return validSearches;
  }

  Future<dynamic> searchItemByIndex(int index, Scope scope)async{

    List<List> rawSearches;
    if(scope == Scope.course){
      CourseRepo cRepo = CourseRepo();
      rawSearches = await cRepo.getList();
    } else{
      StudentRepo sRepo = StudentRepo();
      rawSearches = await sRepo.getList();
    }

    return rawSearches[index];
  }
}

// void main()async{

//     print("start");
//     SearchHandler handler = SearchHandler();
//     var results = await handler.searchItem("BSCS", Scope.student);

//     print('results: $results');

// }