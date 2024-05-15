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

  Future<void> editCsv(int index, List data)async{
    await handler.editCsv(index, data);
  }

  Future<void> deleteCsv(int index)async{
    await handler.deleteCsv(index);
  }

  Future<void> updateCsv(List<List> data) async{
    await handler.appendCsv(data);
  }

  Future<List<List>> getList() async{
    return await handler.readFile();
  }

}