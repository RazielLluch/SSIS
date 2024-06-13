import 'dart:core';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../database/models/student_model.dart';
import '../database/student_db.dart';
import '../misc/scope.dart';

class StudentValidator{

  final String studentId;
  final String year;
  final String? exclude;
  StudentValidator({required this.studentId, required this.year, this.exclude});

  Future<void> validate() async{
    SearchHandler searchHandler = SearchHandler();

    bool validId = false;
    if(await StudentDB().validId(studentId)) {
      validId = true;
    } else {
      throw Exception("A student with that ID number already exists!");
    }

    bool validYear;

    try{
      int value = int.parse(year);
      if(value > 6 || value < 1){
        throw Exception("You entered an invalid year level. Only input a year from 1 to 6!");
      }
      validYear = true;
    }catch (e){
      throw Exception("You entered an invalid year level. Only input a year from 1 to 6!");
    }
  }

}