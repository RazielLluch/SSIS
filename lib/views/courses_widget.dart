import 'package:flutter/material.dart';
import 'package:new_ssis_2/controllers/search_controller.dart';
import 'package:provider/provider.dart';

import '../misc/scope.dart';
import 'add_button.dart';
import 'delete_button.dart';
import 'edit_button.dart';

class CoursesWidget extends StatefulWidget {
  final VoidCallback callback;

  const CoursesWidget({super.key, required this.callback});

  @override
  _CoursesWidgetState createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {

  late List<List> tempData;

  int _selectedIndex = -1;

  void callback(){
    print("courses callback");
    setState(() {
      print("courses callback 2");
      widget.callback();
    });
  }

  void deleteCallback(){
    print("courses callback");

    setState(() {
      print("courses callback 2");
      widget.callback();
      _selectedIndex--;
    });
  }

  void addCallback(){
    print("courses callback");

    setState(() {
      print("courses callback 2");
      widget.callback();
      _selectedIndex = tempData.length;
    });
  }

  void _handleRowTap(int index) {
    setState(() {
      print("preselected index is: $_selectedIndex");
      if(index == _selectedIndex) {
        _selectedIndex = -1;
      }
      else  {
        _selectedIndex = index;
      }
      print("postselected index is: $_selectedIndex");
    });
  }


  @override
  Widget build(BuildContext context) {

    final SearchingController searchingController1 = context.watch<SearchingController>();

    print("new state");

    Future<List<List>> repoData = searchingController1.getSearchResults(Scope.course);
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
                tableElements(tempData),
                Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        DeleteButton(index: _selectedIndex, scope: Scope.student, callback: deleteCallback),
                        EditButton(data: tempData, index: _selectedIndex, callback: callback, scope: Scope.student),
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
                        DeleteButton(index: _selectedIndex, scope: Scope.course, callback: deleteCallback),
                        EditButton(data: snapshot.data!, index: _selectedIndex, callback: callback, scope: Scope.course),
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
    return Container(
      // color: Colors.lightBlueAccent.shade700,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
          children: [
            Container(
                width: 120,
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
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
          children: List<GestureDetector>.generate(data.length, (index) {

            double hPadding = 20;
            double vPadding = 5;
            double inset = 5;

            return GestureDetector(
              onTap: (){
                _handleRowTap(index);
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                    children: [
                      Container(
                          width: 120,
                          margin: EdgeInsets.only(right: inset),
                          padding: EdgeInsets.only(right: inset),
                          decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Colors.lightBlueAccent.withOpacity(0.5)
                                  : Colors.transparent,
                              border: Border.all(
                                  width: 1.2,
                                  color: Colors.grey,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(15))
                          ),
                          child: Container(
                            padding: EdgeInsets.only(top: vPadding, bottom: vPadding, left: hPadding, right: hPadding),
                            child: Text(
                                data[index][0].toString()
                            ),
                          )
                      ),
                      Container(
                          width: 326.6,
                          decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Colors.lightBlueAccent.withOpacity(0.5)
                                  : Colors.transparent,
                              border: Border.all(
                                  width: 1.2,
                                  color: Colors.grey,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(15))
                          ),
                          child: Container(
                            padding: EdgeInsets.only(top: vPadding, bottom: vPadding, left: hPadding),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    data[index][1].toString()
                                ),
                              ),
                            ),
                          )
                      ),
                    ]
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
