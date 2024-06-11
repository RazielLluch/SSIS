import 'dart:core';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../database/models/student_model.dart';
import '../misc/scope.dart';

class CourseValidator{

  final String _courseCode;
  final String _courseName;

  CourseValidator(this._courseCode, this._courseName);

  Future<bool> validate() async{
    SearchHandler searchHandler = SearchHandler();

    if(await searchHandler.searchCourseCode(_courseCode) && await searchHandler.searchCourseName(_courseName)) {
      return true;
    } else {
      return false;
    }

    return true;
  }

}