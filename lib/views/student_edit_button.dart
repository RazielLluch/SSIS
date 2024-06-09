import 'package:flutter/material.dart';
import 'package:new_ssis_2/database/models/student_model.dart';
import 'package:provider/provider.dart';

import '../controllers/search_controller.dart';
import '../handlers/searching_handler.dart';
import '../misc/scope.dart';
import '../repository/course_repo.dart';
import '../repository/student_repo.dart';


class StudentEditButton extends StatefulWidget{
  final StudentModel studentData;
  final VoidCallback callback;
  StudentEditButton({super.key, required this.studentData, required this.callback});

  @override
  State<StudentEditButton> createState() => _StudentEditButton();
}

class _StudentEditButton extends State<StudentEditButton>{

  late int index;

  CourseRepo cRepo = CourseRepo();
  static late Future<List>? courseKeys;

  late StudentRepo sRepo;
  late SearchingController searchingController;
  late SearchHandler searchHandler;

  final sCourseController = TextEditingController();
  final genderController = TextEditingController();
  late dynamic _dropdownValue;
  late dynamic _genderDropdownValue;

  Scope scope = Scope.student;

  List<TextEditingController>  controllers = [];

  @override
  void initState() {
    searchHandler = SearchHandler();
    searchingController = context.read<SearchingController>(); // Initialize the controller
    super.initState();
  }

  void callback(){
    print("edit callback");
    widget.callback();
  }

  void initControllers()async{
    int length;

    index = await searchHandler.searchIndexById(widget.studentData.id, scope);

    length = 4;

    for(int i = 0; i < length; i++){
      controllers.add(TextEditingController());
    }

    sCourseController.text = widget.studentData.course!;

    print("controllers length: ${controllers.length}");
  }

  void _setControllers()async{
    int length;

    length = 4;

    controllers[0].text = widget.studentData.id.toString();
    controllers[1].text = widget.studentData.name.toString();
    controllers[2].text = widget.studentData.year.toString();
    controllers[3].text = widget.studentData.gender.toString();
  }

  void _resetControllers(){
    int length;

    length = 4;

    for(int i = 0; i < length; i++){
      controllers[i].clear();
    }
  }

  void _editInfo(List data)async{
    sRepo = StudentRepo();
    if(data[4] == "CourseCode"){
      data[4] = "Not enrolled";
    }

    int index = await searchHandler.searchIndexById(widget.studentData.id, Scope.student);
    print("the index of the student to edit is $index");

    await sRepo.editCsv(index, data);
    searchingController.defaultStudentSearch();

    print(data);
  }

  //this function is only used in the scope of a student
  dropdownCallback(dynamic selectedValue){
    if (selectedValue is String){
      setState(() {
        sCourseController.text = selectedValue;
      });
    }
  }

  FutureBuilder dropdownButtonBuilder(Future<List>? items){
    return FutureBuilder(
      future: items,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {

          List dropdownItems = snapshot.data!;

          print(snapshot.data!);

          if(widget.studentData.course == null || widget.studentData.course.toString() == "Not enrolled" || widget.studentData.course.toString().isEmpty){
            _dropdownValue = snapshot.data![0];
          }else{
            _dropdownValue = widget.studentData.course;
          }

          print(_dropdownValue);

          return Expanded(
              child: DropdownButton(
                value: _dropdownValue,
                items: dropdownItems.map((dynamic value) {

                  String value2;

                  if(value == "CourseCode"){
                    value2 = "Not enrolled";
                  }else{
                    value2 = value;
                  }

                  return DropdownMenuItem(
                    value: value,
                    child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(value2)
                    ),
                  );
                }).toList(),
                onChanged: dropdownCallback,
              )
          );
        }
      },
    );
  }

  genderDropdown(List genders) {
    // If the student has a gender set, use that as the initial value, otherwise default to the first item in the list.
    _genderDropdownValue = widget.studentData.gender ?? genders[0];

    return Expanded(
      child: DropdownButton(
        value: _genderDropdownValue,
        items: genders.map((dynamic value) {
          return DropdownMenuItem(
            value: value,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(value),
            ),
          );
        }).toList(),
        onChanged: (selectedValue) {
          if (selectedValue is String) {
            setState(() {
              _genderDropdownValue = selectedValue;
              genderController.text = selectedValue;
            });
          }
        },
      ),
    );
  }


  Dialog dialogBuilder(){

    double height;
    double width = 350;
    List<String> columns;
    height = 450;
    columns = ["ID Number", "Name", "Year Level", "Gender", "Course Code"];

    List<Widget> dialogElements = [
      const Text(
          "Edit student"
      )
    ];
    int length = 3;

    for(int i = 0; i < length; i++){
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

    List genders = ["N/A","Male", "Female", "Non-binary", "other"];

    dialogElements.add(
      Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
              children: [
                genderDropdown(genders)
              ]
          )
      ),
    );


    Future<List> courseKeys = cRepo.listPrimaryKeys();

    dialogElements.add(
      Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
              children: [
                dropdownButtonBuilder(
                    courseKeys
                )
              ]
          )
      ),
    );


    dialogElements.add(
        Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: const Text("edit"),
              onPressed: (){

                List data = [];
                for(int i = 0; i < controllers.length; i++){
                  data.add(controllers[i].text);
                }
                data.add(sCourseController.text);


                _editInfo(data);
                _resetControllers();

                callback();
                Navigator.pop(context);

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

    sRepo = StudentRepo();
    courseKeys = cRepo.listPrimaryKeys();




    if(widget.studentData.id == ""){
      return FloatingActionButton(
        onPressed:  null,
        backgroundColor: Colors.grey,
        tooltip: 'Select a student to edit first!',
        child: const Icon(Icons.edit),
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
        tooltip: 'Edit student',
        child: const Icon(Icons.edit),
      );
    }
  }
}