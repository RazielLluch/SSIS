
import 'package:flutter/material.dart';

class CoursesWidget extends StatefulWidget {

  const CoursesWidget({super.key});

  @override
  _CoursesWidgetState createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  int selectedRowIndex = -1; // Index of the selected row

  List<List> data = [["CourseId", "CourseCode"]];

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(
          top: 15,
          left: 7,
          bottom: 15
      ),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.2,
              color: Colors.grey,
              style: BorderStyle.solid
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      padding: const EdgeInsets.only(top: 15, right: 7.5, bottom: 15),
      width: 398.8,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
                child: Row(
                    children: List<Container>.generate(2, (index) {

                      double hPadding = 20;
                      double vPadding = 5;
                      double inset;

                      if(index != 4){
                        inset = 5;
                      }else{
                        inset = 0;
                      }

                      return Container(
                          margin: EdgeInsets.only(right: inset),
                          padding: EdgeInsets.only(right: inset),
                          decoration: BoxDecoration(
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
                                data[0][index]
                            ),
                          )
                      );
                    }
                    )
                )
            )
          ],
        ),
      ),
    );

  }

// Widget buildDataTable(List<List<dynamic>> data) {
//   // Build DataTable with the provided data
//   return ;
//
//
//
// }
}
