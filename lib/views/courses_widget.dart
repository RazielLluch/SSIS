import 'package:flutter/material.dart';
import 'package:new_ssis_2/controllers/search_controller.dart';
import 'package:new_ssis_2/repository/student_repo.dart';
import 'package:provider/provider.dart';

import '../misc/scope.dart';

class CoursesWidget extends StatefulWidget {

  const CoursesWidget({super.key});

  @override
  _CoursesWidgetState createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {

  late List<List> tempData;


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
      child: Column(
        children: [
          tableHeader(),
          FutureBuilder(
            future: repoData,
            builder: (context, snapshot) {

              tempData = snapshot.data!;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return tableElements(tempData);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return tableElements(snapshot.data!);
              }
            },
          ),
        ],
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
          maxHeight: MediaQuery.of(context).size.height * 0.6667, // Adjust the value as needed
        ),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6667, // Adjust the value as needed
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List<Container>.generate(data.length, (index) {

            double hPadding = 20;
            double vPadding = 5;
            double inset = 5;

            Color rowColor = Colors.white;

            return Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                  children: [
                    Container(
                        width: 120,
                        margin: EdgeInsets.only(right: inset),
                        padding: EdgeInsets.only(right: inset),
                        decoration: BoxDecoration(
                            color: rowColor,
                            border: Border.all(
                                width: 1.2,
                                color: Colors.grey,
                                style: BorderStyle.solid
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(15))
                        ),
                        child: Container(
                          padding: EdgeInsets.only(top: vPadding, bottom: vPadding, left: hPadding, right: hPadding),
                          alignment: Alignment.center,
                          child: Text(
                              data[index][0].toString()
                          ),
                        )
                    ),
                    Container(
                        width: 326.6,
                        decoration: BoxDecoration(
                            color: rowColor,
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
            );
          }),
        ),
      ),
    );
  }
}
