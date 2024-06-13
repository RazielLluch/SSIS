import 'dart:core';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../database/models/student_model.dart';
import '../misc/scope.dart';

class CourseValidator{

  final String courseCode;
  final String courseName;
  final String? exclude1;
  final String? exclude2;

  CourseValidator({required this.courseCode,required this.courseName, this.exclude1, this.exclude2});

  Future<void> validate() async{
    SearchHandler searchHandler = SearchHandler();

    bool validCourseCode = false;
    if(await searchHandler.searchCourseCode(courseCode: courseCode, exclude: exclude1)){
      validCourseCode = true;
    }else{
      throw Exception("A course with that code already exists!");
    }

    bool validCourseName = false;
    if(await searchHandler.searchCourseName(courseName: courseName, exclude: exclude2)){
      validCourseName = true;
    }else{
      throw Exception("a course with that name already exists!");
    }

    print("successful course validation");
  }

}