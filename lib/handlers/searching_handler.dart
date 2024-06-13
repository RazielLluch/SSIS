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

  Future<int> searchIndexById(String id, Scope scope) async {
    List<List> rawSearches;

    if (scope == Scope.student) {
      StudentRepo sRepo = StudentRepo();
      rawSearches = await sRepo.getList();

    } else {
      CourseRepo cRepo = CourseRepo();
      rawSearches = await cRepo.getList();
      print("the courses to search: $rawSearches");
    }

    print(rawSearches);

    print("execute for loop");

    print("is for loop valid ${1 < rawSearches.length}");

    for (int i = 1; i < rawSearches.length; i++) {
      if (rawSearches[i][0].toString() == id) {
        print("current index: $i");
        return i;
      }
    }
    return 0;
  }


  Future<List> searchItemById(String id, Scope scope) async{
    if(scope == Scope.student){
      StudentRepo sRepo = StudentRepo();
      List<List> students = await sRepo.getList();
      for(List student in students){
        if(student[0] == id) return student;
      }
      return [];
    }
    else{
      CourseRepo cRepo = CourseRepo();
      List<List> courses = await cRepo.getList();
      for(List course in courses){
        if(course[0] == id) return course;
      }
      return [];
    }
  }

  Future<bool> searchIds({required String id, String? exclude}) async{
    StudentRepo sRepo = StudentRepo();
    List<List> data = await sRepo.getList();
    for(int i = 0 ; i < data.length; i++){
      if(exclude != null && data[i][0] == exclude) continue;
      if(data[i][0] == id) return false;
    }

    return true;
  }

  Future<bool> searchCourseCode({required String courseCode, String? exclude}) async{
    CourseRepo cRepo = CourseRepo();
    List<dynamic> courseCodes = await cRepo.listPrimaryKeys();
    for(dynamic code in courseCodes){
      if(exclude != null && code == exclude) continue;
      if(code == courseCode) return false;
    }

    return true;
  }

  Future<bool> searchCourseName({required String courseName, String? exclude}) async{
    CourseRepo cRepo = CourseRepo();
    List<List> courses= await cRepo.getList();
    for(int i = 0; i < courses.length; i++){
      if(exclude != null && courses[i][1] == exclude) continue;
      if(courses[i][1] == courseName) return false;
    }

    return true;
  }

  // Future<bool> addStudentValidator(String id)async{
  //     StudentRepo sRepo = StudentRepo();
  //     List<List> students = await sRepo.getList();
  //     for(dynamic student in students){
  //       print("currently evaluating studentId ${student[0]} vs $id");
  //       if(student[0] != id) return true;
  //     }
  //     return false;
  // }
  //
  // Future<bool> addCourseValidator(String courseCode, String courseName)async{
  //   CourseRepo cRepo = CourseRepo();
  //   List<List> courses = await cRepo.getList();
  //
  //   for(List course in courses){
  //     if(course[0] != courseCode && course[1] != courseName) return true;
  //   }
  //   return false;
  //
  // }
}