import 'package:flutter/material.dart';
import 'package:new_ssis_2/database/models/course_model.dart';
import 'package:new_ssis_2/database/models/student_model.dart';
import 'package:new_ssis_2/handlers/course_validator.dart';
import 'package:provider/provider.dart';

import '../controllers/search_controller.dart';
import '../database/course_db.dart';
import '../handlers/searching_handler.dart';
import '../misc/scope.dart';
import '../repository/course_repo.dart';
import '../repository/student_repo.dart';


class CourseEditButton extends StatefulWidget{
  final CourseModel courseData;
  final Function(int index, CourseModel courseModel) callback;
  const CourseEditButton({super.key, required this.courseData, required this.callback});

  @override
  State<CourseEditButton> createState() => _CourseEditButton();
}

class _CourseEditButton extends State<CourseEditButton>{

  late int index;

  late CourseRepo cRepo;
  late SearchingController searchingController;
  late SearchHandler searchHandler;

  Scope scope = Scope.course;

  List<TextEditingController>  controllers = [];

  @override
  void initState() {
    searchHandler = SearchHandler();
    searchingController = context.read<SearchingController>(); // Initialize the controller
    super.initState();
  }

  void callback(){
    print("edit callback");
    index = -1;
    widget.callback(index, CourseModel(courseCode: "", name: ""));
  }

  void initControllers()async{
    int length;

    index = await searchHandler.searchIndexById(widget.courseData.courseCode, scope);

    for(int i = 0; i < 2; i++){
      controllers.add(TextEditingController());
    }

    print("controllers length: ${controllers.length}");
  }

  void _setControllers()async{
    controllers[0].text = widget.courseData.courseCode.toString();
    controllers[1].text = widget.courseData.name.toString();
  }

  void _resetControllers(){

    for(int i = 0; i < 2; i++){
      controllers[i].clear();
    }
  }

  Future<void> _editInfo(List data)async{


    try{
      CourseValidator courseValidator = CourseValidator(courseCode: data[0], courseName: data[1], exclude1: widget.courseData.courseCode, exclude2: widget.courseData.name);
      await courseValidator.validate();

      cRepo = CourseRepo();

      String courseCode = widget.courseData.courseCode;

      // int index = await searchHandler.searchIndexById(widget.courseData.courseCode, Scope.course);
      // print("the index of the course to edit is $index");

      // await cRepo.editCsv(index, data);\
      String? newCourseCode;
      if(data[0] == widget.courseData.courseCode) {
        newCourseCode =null;
      } else {
        newCourseCode = data[0];
      }

      await CourseDB().update(courseCode: courseCode, newCourseCode: data[0], name: data[1]);

      // List<int> studentIndexes = await searchHandler.searchItemIndexes(courseCode, Scope.student);
      // print("these are the students to edit: $studentIndexes");
      // StudentRepo sRepo = StudentRepo();
      //
      // for(int studentIndex in studentIndexes){
      //   List student = await searchHandler.searchItemByIndex(studentIndex, Scope.student);
      //   student[4] = data[0];
      //   await sRepo.editCsv(studentIndex, student);
      // }

      await searchingController.defaultCourseSearch();
      await searchingController.defaultStudentSearch();

      _resetControllers();
      callback();
      Navigator.pop(context);

      print(data);
    }catch (e, stackTrace){
      print(stackTrace);
      throw Exception(e.toString());
    }

  }

  void _showErrorDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invalid field entered"),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Dialog dialogBuilder(){
    double height;
    double width = 350;
    List<String> columns;
    height = 450;
    columns = ["Course Code", "Course Name",];

    List<Widget> dialogElements = [
      const Text(
          "Edit course"
      )
    ];

    for(int i = 0; i < 2; i++){
      dialogElements.add(
          TextField(
            controller: controllers[i],
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Input ${columns[i]}'
            ),
          )
      );
    }

    dialogElements.add(
        Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: const Text("edit"),
              onPressed: ()async{

                List data = [];
                for(int i = 0; i < controllers.length; i++){
                  data.add(controllers[i].text);
                }

                try{
                  print("trying edit info");
                  await _editInfo(data);

                }catch (e, stackTrace){
                  print("showing error dialog");
                  print(stackTrace);

                  String errorText = e.toString();
                  errorText = errorText.replaceAll("Exception: Exception: ", "");

                  _showErrorDialog(context, errorText);
                }
              },
            )
        )
    );

    return Dialog(
        child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dialogElements,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context){

    cRepo = CourseRepo();




    if(widget.courseData.courseCode == "" || widget.courseData.courseCode.isEmpty){
      return const FloatingActionButton(
        onPressed:  null,
        backgroundColor: Colors.grey,
        tooltip: 'Select a course to edit first!',
        child: Icon(Icons.edit),
      );
    }
    else{
      if(controllers.isEmpty){
        initControllers();
      }
      return FloatingActionButton(
        onPressed: (){
          _setControllers();

          showDialog(
              context: context,
              builder: (BuildContext context){
                return dialogBuilder();
              }
          );
        },
        tooltip: 'Edit course',
        child: const Icon(Icons.edit),
      );
    }
  }
}