import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:new_ssis_2/views/searchbar_widget.dart';
import 'package:new_ssis_2/views/students_widget.dart';
import 'package:new_ssis_2/views/courses_widget.dart';
// import 'package:new_ssis_2/views/students_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  doWhenWindowReady(() {
    final window = appWindow;
    const initialSize = Size(1280, 720);
    window.minSize = initialSize;
    window.maxSize = initialSize;
    window.size = initialSize;
    window.alignment = Alignment.center;
    window.title = "Simple Student Information System";
    window.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ssis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simple Student Information System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void callback(){
    setState(() {
      print("parent widget refreshed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          )
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0
          ),
          alignment: Alignment.center,
          child: Align(
            alignment: FractionalOffset.topCenter,
            child: Column(
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: FractionalOffset.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SEARCH_BAR_WIDGET
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const SearchBarWidget()
                        ),
                        // STUDENT AND COURSES WIDGETS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const StudentsWidget(),
                            CoursesWidget(),
                          ]
                        )
                      ],
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}
