import 'dart:core';
import 'package:new_ssis_2/handlers/searching_handler.dart';

import '../database/models/student_model.dart';
import '../misc/scope.dart';

class StudentValidator{

  final String _studentId;
  final String _year;

  StudentValidator(this._studentId, this._year);

  Future<bool> validate() async{
    SearchHandler searchHandler = SearchHandler();

    bool validYear;

    try{
      int.parse(_year);
      validYear = true;
    }on Exception{
      validYear = false;
    }

    if(await searchHandler.searchIds(_studentId) && validYear) {
      return true;
    } else {
      return false;
    }
  }

}