import 'dart:io' as io;
import '../handlers/file_handler.dart';


class StudentRepo{

  late FileHandler handler;
  static bool? exists = false;

  StudentRepo(){
    handler = FileHandler('students');
    _init();
  }


  Future<void> _init() async{

    exists = await io.File('${handler.getDirectory()}students.csv').exists();
    // print('Student repository already exists: $exists');
    if(exists == false){
      // print("Initializing student repository");

      await handler.init([["IDNum", "StudentName", "yearLvl", "gender", "Course"]]);

      // print("Student repository has been initialized");
    }else{

      // print("Student repository file has already been initialized");
    }
  }

  void editCsv(int index, List data)async{
    FileHandler handler = FileHandler('students');
    handler.editCsv(index, data);
  }

  void deleteCsv(int index)async{
    FileHandler handler = FileHandler('students');
    handler.deleteCsv(index);
  }

  void updateCsv(List<List> data){
    FileHandler handler = FileHandler('students');
    handler.appendCsv(data);
  }

  Future<List<List>> getList() async{
    FileHandler handler = FileHandler('students');
    return await handler.readFile();
  }

}