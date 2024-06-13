import 'dart:core';
import 'package:new_ssis_2/database/course_db.dart';
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
    if(courseCode != exclude1){
      if (await CourseDB().validCourseCode(courseCode)) {
        validCourseCode = true;
      } else {
        throw Exception("A course with that code already exists!");
      }
    }

    bool validCourseName = false;
    if(courseName != exclude2){
      if (await CourseDB().validCourseName(courseName)) {
        validCourseName = true;
      } else {
        throw Exception("a course with that name already exists!");
      }
    }

    print("successful course validation");
  }

}