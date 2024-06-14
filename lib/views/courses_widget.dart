import 'package:flutter/material.dart';
import 'package:new_ssis_2/controllers/search_controller.dart';
import 'package:new_ssis_2/database/models/course_model.dart';
import 'package:new_ssis_2/views/course_edit_button.dart';
import 'package:provider/provider.dart';

import '../database/models/model.dart';
import '../misc/scope.dart';
import 'CustomRowWidget.dart';
import 'add_button.dart';
import 'delete_button.dart';
import 'student_edit_button.dart';

class CoursesWidget extends StatefulWidget {
  final VoidCallback callback;

  const CoursesWidget({super.key, required this.callback});

  @override
  _CoursesWidgetState createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {

  late List tempData;

  int _selectedIndex = -1;
  String _selectedCourseCode = "";
  CourseModel _selectedCourseModel = CourseModel(courseCode: "", name: "");

  void editCallback(int index, CourseModel courseModel){
    print("courses callback");
    setState(() {
      print("courses callback 2");

      _selectedIndex = index;
      _selectedCourseModel = courseModel;

      widget.callback();
    });
  }

  void deleteCallback(){
    print("courses callback");

    setState(() {
      print("courses callback 2");

      _selectedIndex = -1;
      _selectedCourseModel = CourseModel(courseCode: '', name: '');

      widget.callback();
    });
  }

  void addCallback(){
    print("courses callback");
    setState(() {
      print("courses callback 2");


      _selectedIndex = -1;
      _selectedCourseModel = CourseModel(courseCode: '', name: '');

      widget.callback();
    });
  }

  void _handleRowTap(int index, String id, Model courseModel) {
    setState(() {
      print("preselected index is: $_selectedIndex");
      if (id == _selectedCourseCode) {
        _selectedIndex = -1;
        _selectedCourseCode = "";
        _selectedCourseModel = CourseModel(courseCode: '', name: '');
      } else {
        _selectedIndex = index;
        _selectedCourseCode = id;
        // Check if courseModel is a CourseModel before assigning
        if (courseModel is CourseModel) {
          _selectedCourseModel = courseModel;
        } else {
          // Handle the case where courseModel is not a CourseModel
          throw ArgumentError('Expected a CourseModel, but got ${courseModel.runtimeType}');
        }
      }
      print("postselected index is: $_selectedIndex");
    });
  }



  @override
  Widget build(BuildContext context) {

    final SearchingController searchingController1 = context.watch<SearchingController>();

    print("new state");

    Future<List> repoData = searchingController1.getCourseSearchResults();
    return Container(
      height: 500,
      margin: const EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: FutureBuilder(
        future: repoData,
        builder: (context, snapshot){
          tempData = snapshot.data!;

          if(snapshot.connectionState == ConnectionState.waiting){
            return Column(
              children: [
                tableHeader(),
                tableElements(snapshot.data!),
                Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        DeleteButton(index: _selectedIndex, primaryKey: _selectedCourseCode, scope: Scope.course, callback: deleteCallback),
                        CourseEditButton(courseData: _selectedCourseModel,callback: editCallback),
                        AddButton(callback: addCallback, scope: Scope.course)
                      ],
                    )
                )
              ],
            );
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else{
            return Column(
              children: [
                tableHeader(),
                tableElements(snapshot.data!),
                Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        DeleteButton(index: _selectedIndex, primaryKey: _selectedCourseCode, scope: Scope.course, callback: deleteCallback),
                        CourseEditButton(courseData: _selectedCourseModel,callback: editCallback),
                        AddButton(callback: addCallback, scope: Scope.course)
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
      padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  alignment: Alignment.center,
                  child: const Text(
                      'Course ID'
                  ),
                )
            ),
            Container(
                width: 326.6,
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
                      'Course Name'
                  ),
                )
            ),
          ]
      ),
    );
  }

  ConstrainedBox tableElements(List data) {

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
            return CustomRowWidget(data: data[index], index: index, selectedIndex: _selectedIndex, handleRowTap: _handleRowTap, scope: Scope.course,);
          }),
        ),
      ),
    );
  }
}
