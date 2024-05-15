import 'dart:io' as io;

import '../handlers/file_handler.dart';

class CourseRepo{

  late FileHandler handler;
  static bool? exists;

  CourseRepo(){
    handler = FileHandler('courses');
    _init();
  }

  Future<void> _init() async{

    exists = await io.File('${handler.getDirectory()}courses.csv').exists();
    // print('Course repository already exists: $exists');
    if(exists == false){
      // print("Initializing course repository");

      await handler.init([["CourseCode", "CourseName"]]);

      // print("Course repository has been initialized");

    }else{

      // print("Course repository file has already been initialized");

    }

  }

  Future<void> editCsv(int index, List data)async{
    await handler.editCsv(index, data);

  }

  Future<void> deleteCsv(int index)async{
    await handler.deleteCsv(index);
  }

  Future<void> updateCsv(List<List> data)async{
    await handler.appendCsv(data);
  }

  Future<List> listPrimaryKeys()async{
    List keys = await handler.readFile();
    List result = [];
    for(int i = 0; i < keys.length; i++){
      result.add(keys[i][0]);
    }

    return result;
  }

  Future<List<List>> getList() async{
    FileHandler handler = FileHandler('courses');
    return await handler.readFile();
  }

}