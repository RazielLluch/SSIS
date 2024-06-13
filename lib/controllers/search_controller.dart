import 'package:flutter/cupertino.dart';
import 'package:new_ssis_2/database/student_db.dart';
import 'package:new_ssis_2/database/models/course_model.dart';
import 'package:new_ssis_2/database/models/student_model.dart';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../database/course_db.dart';
import '../database/models/model.dart';
import '../misc/scope.dart';

class SearchingController extends ChangeNotifier{

  SearchHandler searchHandler = SearchHandler();
  
  late List<StudentModel> _studentSearchResults = [];
  late List<CourseModel> _courseSearchResults = [];

  SearchingController(){
    initialize();
  }

  Future<void> initialize() async {

    await defaultStudentSearch();

    await defaultCourseSearch();
  }

  Future<List<dynamic>> getSearchResults(Scope scope) async{
    if(scope == Scope.student) {
      return _studentSearchResults;
    } else {
      return _courseSearchResults;
    }
  }

  Future<void> defaultStudentSearch()async{

    _studentSearchResults = await StudentDB().fetchBySearch("");
    print("notifying students");
    notifyListeners();
  }

  Future<void> defaultCourseSearch()async{

    _courseSearchResults = await CourseDB().fetchBySearch("");
    print("notifying courses");
    notifyListeners();
  }


  Future<void> searchResult(Future<List<List<dynamic>>> value, Scope scope) async{
    List<List> values = await value;

    if(scope == Scope.student){
      List<StudentModel> students = [];
      if(values.isNotEmpty){
        for(List item in values){
          students.add(StudentModel(
              id: item[0],
              name: item[1],
              year: item[2],
              gender: item[3],
              course: item[4]
          ));
        }
      }

      _studentSearchResults = students;
    }else{
      List<CourseModel> courses = [];
      if(values.isNotEmpty){
        for(List item in values){
          courses.add(CourseModel(
            courseCode: item[0],
            name: item[1],
          ));
        }
      }

      _courseSearchResults = courses;
    }

    print("printing from search_controller $value");
    notifyListeners();
  }
}