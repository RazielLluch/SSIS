import 'package:flutter/material.dart';

import '../repository/course_repo.dart';
import '../repository/student_repo.dart';


class AddButton extends StatefulWidget{
  final VoidCallback callback;
  const AddButton({super.key, required this.callback});

  @override
  State<AddButton> createState() => _AddButton();
}

class _AddButton extends State<AddButton>{

  CourseRepo cRepo = CourseRepo();
  static late Future<List> courseKeys;

  StudentRepo sRepo = StudentRepo();
  late Future<List<List>> data;

  final sIDController = TextEditingController();
  final sNameController = TextEditingController();
  final sYrController = TextEditingController();
  final sGenderController = TextEditingController();
  final sCourseController = TextEditingController();
  late dynamic _dropdownValue;

  void _resetControllers(){
    sIDController.clear();
    sNameController.clear();
    sYrController.clear();
    sGenderController.clear();
    sCourseController.clear();
  }

  void _addInfo(List data){
    sRepo = StudentRepo();
    sRepo.updateCsv([data]);

    setState((){
    });
  }

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

          List _dropdownItems = snapshot.data!;
          _dropdownValue = snapshot.data![0];

          return Expanded(
              child: DropdownButton(
                value: _dropdownValue,
                items: _dropdownItems.map((dynamic value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
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

  @override
  Widget build(BuildContext context){

    return FloatingActionButton(
      onPressed: (){

        courseKeys = cRepo.listPrimaryKeys();
        data = sRepo.getList();

        showDialog(
            context: context,
            builder: (BuildContext context){
              return Dialog(
                  child: Container(
                      height: 450,
                      width: 350,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              "Add New Student"
                          ),
                          TextField(
                            controller: sIDController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Input ID Number'
                            ),
                          ),
                          TextField(
                            controller: sNameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Input Name'
                            ),
                          ),
                          TextField(
                            controller: sYrController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Input Year Level'
                            ),
                          ),
                          TextField(
                            controller: sGenderController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Input Gender'
                            ),
                          ),
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
                          Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: const Text("add"),
                                onPressed: (){
                                  _addInfo([sIDController.text,sNameController.text,sYrController.text,sGenderController.text,sCourseController.text]);
                                  _resetControllers();
                                  Navigator.pop(context);
                                  widget.callback();
                                },
                              )
                          )
                        ],
                      )
                  )
              );
            }
        );
      },
      tooltip: 'Add Student',
      child: const Icon(Icons.add),
    );
  }
}