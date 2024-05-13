import 'package:flutter/material.dart';
import 'package:new_ssis_2/controllers/search_controller.dart';
import 'package:provider/provider.dart';

import '../handlers/searching_handler.dart';
import '../misc/scope.dart';
import '../repository/course_repo.dart';
import '../repository/student_repo.dart';


class DeleteButton extends StatefulWidget{
  final int index;
  final VoidCallback callback;
  final Scope scope;
  const DeleteButton({super.key, required this.index, required this.scope, required this.callback});

  @override
  State<DeleteButton> createState() => _DeleteButton();
}

class _DeleteButton extends State<DeleteButton>{

  late String scope;
  CourseRepo cRepo = CourseRepo();

  late StudentRepo sRepo = StudentRepo();
  late SearchHandler searchHandler;
  late SearchingController searchingController;

  @override
  void initState() {
    searchHandler = SearchHandler();
    searchingController = context.read<SearchingController>(); // Initialize the controller
    super.initState();
  }

  void callback(){
    print("add callback");
    widget.callback();
  }

  void _deleteInfo()async{

    if(widget.scope == Scope.student){
      await sRepo.deleteCsv(widget.index+1);
    }else{
      SearchHandler searchHandler = SearchHandler();
      List courseCodes = await cRepo.listPrimaryKeys();
      String courseCode = courseCodes[widget.index+1];

      print("selected course code: $courseCode");

      List enrolledStudents = await searchHandler.searchItemIndexes(courseCode, Scope.student);

      for(int i = 0; i < enrolledStudents.length; i++){
        List<List> editList = await sRepo.getList();
        List currentData = editList[enrolledStudents[i]];
        currentData[4] = "Not enrolled";
        sRepo.editCsv(enrolledStudents[i], currentData);
      }

      await cRepo.deleteCsv(widget.index+1);

    }

    searchingController.searchResult(searchHandler.searchItem("", widget.scope), widget.scope);
  }

  @override
  Widget build(BuildContext context){

    if(widget.scope == Scope.student){
      scope = "Student";
    }else{
      scope = "Course";
    }



    if(widget.index == -1){
      return FloatingActionButton(
        onPressed:  null,
        backgroundColor: Colors.grey,
        tooltip: 'Select a $scope to delete first!',
        child: const Icon(Icons.delete),
      );
    }
    else{
      print("the scope of the delete button is: $scope");
      return FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return Dialog(
                    child: Container(
                        height: 200,
                        width: 350,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Are you sure you want to delete this $scope?"
                            ),
                            Row(
                              children: [
                                Container(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: const Text("cancel"),
                                      onPressed: (){
                                        Navigator.pop(context);
                                        widget.callback();
                                      },
                                    )
                                ),
                                Container(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: const Text("confirm"),
                                      onPressed: (){
                                        _deleteInfo();
                                        Navigator.pop(context);
                                        callback();
                                      },
                                    )
                                )
                              ],
                            )
                          ],
                        )
                    )
                );
              }
          );
        },
        tooltip: 'Delete $scope',
        child: const Icon(Icons.delete),
      );
    }
  }
}