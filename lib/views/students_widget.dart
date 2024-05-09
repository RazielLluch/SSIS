import 'package:flutter/material.dart';
import 'package:new_ssis_2/controllers/search_controller.dart';
import 'package:new_ssis_2/repository/student_repo.dart';
import 'package:provider/provider.dart';

class StudentsWidget extends StatefulWidget {

  const StudentsWidget({super.key});

  @override
  _StudentsWidgetState createState() => _StudentsWidgetState();
}

class _StudentsWidgetState extends State<StudentsWidget> {

  StudentRepo sRepo = StudentRepo();

  @override
  void initState(){
    SearchingController searchingController = context.read<SearchingController>();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final SearchingController searchingController1 = context.watch<SearchingController>();

    print("new state");

        Future<List<List>> repoData = searchingController1.getSearchResults();
        return Container(
          height: 500,
          margin: const EdgeInsets.only(
            top: 15,
            right: 7,
            bottom: 15,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.2,
              color: Colors.white,
              style: BorderStyle.solid,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              tableHeader(),
              FutureBuilder(
                future: repoData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    snapshot.data!.removeAt(0);
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
      padding: const EdgeInsets.all(5),
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
                      'ID Num'
                  ),
                )
            ),
            Container(
                width: 298,
                padding: const EdgeInsets.only(right: 5),
                margin: const EdgeInsets.only(right: 5),
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
                      'Full Name'
                  ),
                )
            ),
            Container(
                width: 80,
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
                      'Year'
                  ),
                )
            ),
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
                      'Gender'
                  ),
                )
            ),
            Container(
                width: 120,
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
                      'Course'
                  ),
                )
            ),
          ]
      ),
    );
  }

  ConstrainedBox tableElements(List<List<dynamic>> data) {

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
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
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
                        width: 300,
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
                          child: Text(
                              data[index][1].toString()
                          ),
                        )
                    ),
                    Container(
                        width: 80,
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
                              data[index][2].toString()
                          ),
                        )
                    ),
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
                              data[index][3]
                          ),
                        )
                    ),
                    Container(
                        width: 120,
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
                          padding: EdgeInsets.only(left: hPadding, top: vPadding, bottom: vPadding),
                          child: Text(
                              data[index][4].toString()
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
