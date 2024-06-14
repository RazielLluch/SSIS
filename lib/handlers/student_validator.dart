import 'dart:core';
import 'package:new_ssis_2/handlers/searching_handler.dart';
import '../database/student_db.dart';

class StudentValidator{

  final String studentId;
  final String name;
  final String year;
  final String? exclude1;
  final String? exclude2;
  StudentValidator({required this.studentId, required this.name, required this.year, this.exclude1, this.exclude2});

  Future<void> validate() async{

    bool validId = false;
    if(studentId != exclude1){
      if (await checkIfIdIsValid(studentId) && await StudentDB().validId(studentId)) {
        validId = true;
      } else {
        throw Exception('A student with that ID number already exists!');
      }
    }

    bool validName;

    if(name != exclude2){
      if (await StudentDB().validName(name)) {
        validName = true;
      } else {
        throw Exception('A student with this name already exists');
      }
    }

    bool validYear;

    try{
      int value = int.parse(year);
      if(value > 6 || value < 1){
        throw Exception('You entered an invalid year level. Only input a year from 1 to 6!' );
      }
      validYear = true;
    }catch (e){
      throw Exception('You entered an invalid year level. Only input a year from 1 to 6!');
    }

  }

  Future<bool> checkIfIdIsValid(String id)async{
    try{
      if(id.length > 9 || id.isEmpty) return false;
      bool validId = false;
      int year = int.parse(id.substring(0, 4));
      if(year < 1930 && year < 2025) return false;
      if(id.substring(4,5) == '-') {
        validId = true;
      } else{
        return false;
      }
      int.parse(id.substring(5,9));
      return validId;
    }catch (e){
      return false;
    }
  }
}