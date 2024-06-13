import 'package:flutter/material.dart';
import 'package:new_ssis_2/controllers/search_controller.dart';
import 'package:new_ssis_2/repository/student_repo.dart';
import 'package:new_ssis_2/views/CustomRowWidget.dart';
import 'package:new_ssis_2/views/delete_button.dart';
import 'package:provider/provider.dart';

import '../database/models/model.dart';
import '../database/models/student_model.dart';
import '../misc/scope.dart';
import 'add_button.dart';
import 'student_edit_button.dart';

class StudentsWidget extends StatefulWidget {
  final VoidCallback callback;

  const StudentsWidget({super.key, required this.callback});

  @override
  _StudentsWidgetState createState() => _StudentsWidgetState();
}

class _StudentsWidgetState extends State<StudentsWidget> {

  StudentRepo sRepo = StudentRepo();
  late List<List> tempData;
  late Future<List<List>> repoData;
  int _selectedIndex = -1;
  String _selectedId = "";

  late StudentModel? _selectedStudentModel = StudentModel(id: '', name: '', gender: '=');

/*  @override
  void initState() {
    repoData = sRepo.getList();
    super.initState();
  }*/

  void editCallback(int index, StudentModel studentModel){
    print("students callback");
    setState(() {
      print("students callback 2");

      _selectedIndex = index;
      _selectedStudentModel = studentModel;

      widget.callback();
    });
  }

  void deleteCallback(){
    print("students callback");
    setState(() {
      print("students callback 2");

      _selectedIndex = -1;
      _selectedStudentModel = StudentModel(id: '', name: '', gender: '');


      widget.callback();
    });
  }

  void addCallback(){
    print("students callback");
    setState(() {
      print("students callback 2");

      _selectedIndex = -1;
      _selectedStudentModel = StudentModel(id: '', name: '', gender: '');

      widget.callback();
    });
  }


  void _handleRowTap(int index, String id, Model studentModel) {
    setState(() {
      print("preselected index is: $_selectedIndex");
      if(id == _selectedId) {
        _selectedIndex = -1;
        _selectedId = "";
        _selectedStudentModel = StudentModel(id: '', name: '', gender: '=');
      }
      else  {
        _selectedIndex = index;
        _selectedId = id;
        if(studentModel is StudentModel){
          _selectedStudentModel = studentModel;
        }
        else{
          throw ArgumentError('Expected a StudentModel, but got ${studentModel.runtimeType}');
        }
      }
      print("postselected index is: $_selectedIndex");
    });
  }


  @override
  Widget build(BuildContext context) {

    print("selected index: $_selectedIndex");

    final SearchingController searchingController1 = context.watch<SearchingController>();

    print("new state");

    repoData = searchingController1.getSearchResults(Scope.student);
    return Container(
      height: 500,
      margin: const EdgeInsets.only(
        top: 15,
        right: 7,
        bottom: 15,
      ),
      child: FutureBuilder(
        future: repoData,
        builder: (context, snapshot){
          tempData = snapshot.data!;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                tableHeader(),
                tableElements(tempData),
                Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        DeleteButton(index: _selectedIndex, scope: Scope.student, callback: deleteCallback),
                        StudentEditButton(studentData: _selectedStudentModel!,callback: editCallback),
                        AddButton(callback: addCallback, scope: Scope.student)
                      ],
                    )
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                tableHeader(),
                tableElements(snapshot.data!),
                Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        DeleteButton(index: _selectedIndex, scope: Scope.student, callback: deleteCallback),
                        StudentEditButton(studentData: _selectedStudentModel!, callback: editCallback),
                        AddButton(callback: addCallback, scope: Scope.student)
                      ],
                    )
                )
              ],
            );
          }
        },

      ),
    );
  }


  Container tableHeader(){

    Color headerColor = const Color(0xffE8E8E8);

    return Container(
      padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
      child: Row(
          children: [
            Container(
                width: 120,
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: headerColor,
                    border: Border.all(
                        width: 1.2,
                        color: Colors.grey,
                        style: BorderStyle.solid
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20,  right: 20),
                  alignment: Alignment.center,
                  child: const Text(
                      'ID Num'
                  ),
                )
            ),
            Container(
                width: 298,
                padding: const EdgeInsets.only(right: 5),
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: headerColor,
                    border: Border.all(
                        width: 1.2,
                        color: Colors.grey,
                        style: BorderStyle.solid
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  alignment: Alignment.center,
                  child: const Text(
                      'Full Name'
                  ),
                )
            ),
            Container(
                width: 80,
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: headerColor,
                    border: Border.all(
                        width: 1.2,
                        color: Colors.grey,
                        style: BorderStyle.solid
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  alignment: Alignment.center,
                  child: const Text(
                      'Year'
                  ),
                )
            ),
            Container(
                width: 120,
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: headerColor,
                    border: Border.all(
                        width: 1.2,
                        color: Colors.grey,
                        style: BorderStyle.solid
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  alignment: Alignment.center,
                  child: const Text(
                      'Gender'
                  ),
                )
            ),
            Container(
                width: 120,
                decoration: BoxDecoration(
                    color: headerColor,
                    border: Border.all(
                        width: 1.2,
                        color: Colors.grey,
                        style: BorderStyle.solid
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  alignment: Alignment.center,
                  child: const Text(
                      'Course'
                  ),
                )
            ),
          ]
      ),
    );
  }

  ConstrainedBox tableElements(List<List<dynamic>> data) {

    if(data.isEmpty) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5845,
          maxHeight: MediaQuery.of(context).size.height * 0.5845, // Adjust the value as needed
        ),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5845,
        maxHeight: MediaQuery.of(context).size.height * 0.5845, // Adjust the value as needed
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List<CustomRowWidget>.generate(data.length, (index) {
            return CustomRowWidget(data: data[index], index: index, selectedIndex: _selectedIndex, handleRowTap: _handleRowTap, scope: Scope.student);
          }),
        ),
      ),
    );
  }
}
