import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/search_controller.dart';
import '../handlers/searching_handler.dart';
import '../misc/scope.dart';
import '../repository/course_repo.dart';
import '../repository/student_repo.dart';


class AddButton extends StatefulWidget{
  final VoidCallback callback;
  final Scope scope;
  const AddButton({super.key,  required this.callback, required this.scope});

  @override
  State<AddButton> createState() => _AddButton();
}

class _AddButton extends State<AddButton>{

  late String scope;
  CourseRepo cRepo = CourseRepo();
  static late Future<List>? courseKeys;

  late StudentRepo sRepo;
  late Future<List<List>> data;
  late SearchingController searchingController;
  late SearchHandler searchHandler;

  final sCourseController = TextEditingController();
  final genderController = TextEditingController();
  late dynamic _dropdownValue;
  late dynamic _genderDropdownValue;

  List<TextEditingController>  controllers = [];

  @override
  void initState() {
    searchHandler = SearchHandler();
    searchingController = context.read<SearchingController>(); // Initialize the controller
    initControllers();
    super.initState();
  }

  void callback(){
    print("add callback");
    widget.callback();
  }

  void initControllers(){
    int length;

    if(widget.scope == Scope.student) {
      length = 3;
    } else {
      length = 2;
    }

    for(int i = 0; i < length; i++){
      controllers.add(TextEditingController());
    }

    print("controllers length: ${controllers.length}");
  }

  void _resetControllers(){
    controllers.clear;
  }

  void _addInfo(List data)async{
    if(widget.scope == Scope.student){
      await sRepo.updateCsv([data]);
      _resetControllers();
      await searchingController.searchResult(searchHandler.searchItem("", Scope.student), Scope.student);
    }
    else{
      await cRepo.updateCsv([data]);
      _resetControllers();
      await searchingController.searchResult(searchHandler.searchItem("", Scope.course), Scope.course);
    }
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

          snapshot.data[0] = "Course";

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

  genderDropdown(List genders){

    List dropdownItems = genders;
    _genderDropdownValue = genders[0];

    return Expanded(
        child: DropdownButton(
          value: _genderDropdownValue,
          items: dropdownItems.map((dynamic value) {
            return DropdownMenuItem(
              value: value,
              child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(value)
              ),
            );
          }).toList(),
          onChanged: (selectedValue){
            if (selectedValue is String){
              setState(() {
                genderController.text = selectedValue;
              });
            }
          },
        )
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
          "Add $scope"
      )
    ];
    int length;
    if(widget.scope == Scope.student) {
      length = 3;
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

      dialogElements.add(
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
                children: [
                  dropdownButtonBuilder(courseKeys)
                ]
            )
        ),
      );
    }

    dialogElements.add(
        Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: const Text("add"),
              onPressed: (){

                List data = [];
                for(int i = 0; i < controllers.length; i++){
                  data.add(controllers[i].text);
                }
                if(widget.scope == Scope.student) {
                  data.add(genderController.text);
                  data.add(sCourseController.text);
                }

                _addInfo(data);

                Navigator.pop(context);
                callback();
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

    return FloatingActionButton(
      onPressed: (){

        showDialog(
            context: context,
            builder: (BuildContext context){
              return dialogBuilder();
            }
        );
      },
      tooltip: 'Add $scope',
      child: const Icon(Icons.add),
    );
  }
}