import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/search_controller.dart';
import '../handlers/searching_handler.dart';
import '../misc/scope.dart';
import '../repository/course_repo.dart';
import '../repository/student_repo.dart';


class EditButton extends StatefulWidget{
  final int index;
  List<List> data;
  final VoidCallback callback;
  final Scope scope;
  EditButton({super.key, required this.data,required this.index, required this.callback, required this.scope});

  @override
  State<EditButton> createState() => _EditButton();
}

class _EditButton extends State<EditButton>{

  late String scope;
  CourseRepo cRepo = CourseRepo();
  static late Future<List>? courseKeys;

  late StudentRepo sRepo;
  late Future<List<List>> data;
  late SearchingController searchingController;
  late SearchHandler searchHandler;

  final sCourseController = TextEditingController();
  late dynamic _dropdownValue;

  List<TextEditingController>  controllers = [];

  @override
  void initState() {
    searchHandler = SearchHandler();
    searchingController = context.read<SearchingController>(); // Initialize the controller
    super.initState();
  }

  void initControllers(){
    int length;

    if(widget.scope == Scope.student) {
      length = 4;
    } else {
      length = 2;
    }

    for(int i = 0; i < length; i++){
      controllers.add(TextEditingController());
    }

    print("controllers length: ${controllers.length}");
  }

  void _setControllers(){
    int length;

    if(widget.scope == Scope.student) {
      length = 4;
    } else {
      length = 2;
    }

    for(int i = 0; i < length; i++){
      controllers[i].text = widget.data[widget.index][i].toString();
    }
  }

  void _resetControllers(){
    int length;

    if(widget.scope == Scope.student) {
      length = 4;
    } else {
      length = 2;
    }

    for(int i = 0; i < length; i++){
      controllers[i].clear();
    }
  }

  void _editInfo(List data)async{
    if(widget.scope == Scope.student){
      sRepo = StudentRepo();
      sRepo.editCsv(widget.index+1, data);
    }
    else{

      SearchHandler searchHandler = SearchHandler();
      List courseCodes = await cRepo.listPrimaryKeys();
      String courseCode = courseCodes[widget.index+1];

      List enrolledStudents = await searchHandler.searchItem(courseCode, Scope.student);

      for(int i = 0; i < enrolledStudents.length; i++){
        List<List> editList = await sRepo.getList();
        List currentData = editList[enrolledStudents[i]];
        currentData[4] = data[0];
        sRepo.editCsv(enrolledStudents[i], currentData);
      }

      cRepo.editCsv(widget.index+1, data);
    }

    print(data);

    searchingController.searchResult(searchHandler.searchItem("", widget.scope), widget.scope);
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
          _dropdownValue = snapshot.data![0];

          return Expanded(
              child: DropdownButton(
                value: _dropdownValue,
                items: dropdownItems.map((dynamic value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(value)
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

  Dialog dialogBuilder(){

    double height;
    double width = 350;
    List<String> columns;
    if(widget.scope == Scope.student){
      height = 450;
      columns = ["ID Number", "Name", "Year Level", "Gender", "Course Code"];
      scope = "student";
    }else{
      height = 270;
      columns = ["Course Code", "Course Name"];
      scope = "course";
    }

    List<Widget> dialogElements = [
      Text(
          "Edit $scope"
      )
    ];
    int length;
    if(widget.scope == Scope.student) {
      length = 4;
    } else {
      length = 2;
    }

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

    if(widget.scope == Scope.student){

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
    }

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
                if(widget.scope == Scope.student) data.add(sCourseController.text);


                _editInfo(data);
                _resetControllers();

                Navigator.pop(context);
                widget.callback();
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

    if(widget.scope == Scope.student){
      scope = "Student";
    }else{
      scope = "Course";
    }

    sRepo = StudentRepo();
    courseKeys = cRepo.listPrimaryKeys();
    data = sRepo.getList();

    if(widget.index == -1){
      return FloatingActionButton(
        onPressed:  null,
        backgroundColor: Colors.grey,
        tooltip: 'Select a $scope to edit first!',
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
        tooltip: 'Edit $scope',
        child: const Icon(Icons.edit),
      );
    }
  }
}