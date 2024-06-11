import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_ssis_2/database/models/course_model.dart';
import 'package:new_ssis_2/database/models/student_model.dart';
import '../database/models/model.dart';
import '../misc/scope.dart';

class CustomRowWidget extends StatefulWidget {
  final List<dynamic> data;
  final Function(int, String, Model) handleRowTap;
  final int selectedIndex;
  final int index;
  final Scope scope;
  CustomRowWidget({required this.data, required this.index, required this.selectedIndex, required this.handleRowTap, required this.scope});

  @override
  _CustomRowWidgetState createState() => _CustomRowWidgetState();
}

class _CustomRowWidgetState extends State<CustomRowWidget> {



  @override
  Widget build(BuildContext context) {
    int _selectedIndex = widget.selectedIndex;
    int index = widget.index;

    double hPadding = 20;
    double vPadding = 5;
    double inset = 5;


    Model model;

    List<double> widths;

    int length;
    if(widget.scope == Scope.student){
      model = StudentModel(id: widget.data[0].toString(), name: widget.data[1].toString(), year: widget.data[2], gender: widget.data[3].toString(), course: widget.data[4].toString());
      widths = [120, 300, 80, 117.4, 120];
      length = 5;
    }else{
      model = CourseModel(courseCode: widget.data[0], name: widget.data[1]);
      widths = [120, 326.6];
      length = 2;
    }

        return GestureDetector(
          onTap: () {
            widget.handleRowTap(widget.index, widget.data[0].toString(), model);
          },
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: List<Widget>.generate(length, (listIndex) {

                if(widget.scope == Scope.course){
                  return _buildScrollableCell(
                    context,
                    width: widths[listIndex],
                    content: widget.data[listIndex].toString(),
                    isSelected: _selectedIndex == index,
                    hPadding: hPadding,
                    vPadding: vPadding,
                    inset: inset,
                    alignment: listIndex == 1 ? Alignment.centerLeft : Alignment.center,
                  );
                }else if(listIndex == 4){
                  return _buildScrollableCell(
                    context,
                    width: 120,
                    content: widget.data[listIndex].toString(),
                    isSelected: _selectedIndex == index,
                    hPadding: hPadding,
                    vPadding: vPadding,
                    inset: inset,
                    alignment: Alignment.center,
                  );
                }else{
                  return _buildCell(
                    context,
                    width: widths[listIndex],
                    content: widget.data[listIndex].toString(),
                    isSelected: _selectedIndex == index,
                    hPadding: hPadding,
                    vPadding: vPadding,
                    inset: inset,
                  );
                }
              }),
            ),
          ),
        );
  }

  Widget _buildCell(BuildContext context,
      {required double width,
        required String content,
        required bool isSelected,
        required double hPadding,
        required double vPadding,
        required double inset}) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: inset),
      padding: EdgeInsets.only(right: inset),
      decoration: BoxDecoration(
        color: isSelected ? Colors.lightBlueAccent.withOpacity(0.5) : const Color(0xffEDEDED),
        border: Border.all(
          width: 1.2,
          color: Colors.grey,
          style: BorderStyle.solid,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Container(
        padding: EdgeInsets.only(top: vPadding, bottom: vPadding, left: hPadding, right: hPadding),
        alignment: Alignment.center,
        child: Text(content),
      ),
    );
  }

  Widget _buildScrollableCell(BuildContext context,
      {required double width,
        required String content,
        required bool isSelected,
        required double hPadding,
        required double vPadding,
        required double inset,
        required AlignmentGeometry alignment}) {
    return Container(
      width: width,
      // margin: EdgeInsets.only(right: inset),
      padding: EdgeInsets.only(right: inset),
      decoration: BoxDecoration(
        color: isSelected ? Colors.lightBlueAccent.withOpacity(0.5) : const Color(0xffEDEDED),
        border: Border.all(
          width: 1.2,
          color: Colors.grey,
          style: BorderStyle.solid,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Container(
        alignment: alignment,
        padding: EdgeInsets.only(top: vPadding, bottom: vPadding, left: hPadding, right: hPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                child: Text(content),
            ),
          ),
        ),
      ),
    );
  }
}
