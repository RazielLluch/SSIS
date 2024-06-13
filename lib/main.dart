
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:new_ssis_2/database/SsisDatabase.dart';
import 'package:new_ssis_2/views/searchbar_widget.dart';
import 'package:new_ssis_2/views/students_widget.dart';
import 'package:new_ssis_2/views/courses_widget.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'controllers/search_controller.dart';

void main() {

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  doWhenWindowReady(() {
    final window = appWindow;
    const initialSize = Size(1321, 720);
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
    print("main callback");
    setState(() {
      print("main callback 2");
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
      body: Container(
        color: const Color(0xffEAEAEA),
        child: Center(
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
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: ChangeNotifierProvider(
                      create: (_) => SearchingController(),
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
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const SearchBarWidget()
                          ),
                          // STUDENT AND COURSES WIDGETS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StudentsWidget(callback: callback),
                              CoursesWidget(callback: callback),
                            ]
                          )
                        ],
                      ),
                    )
                  )
                ]
              )
            )
          )
        ),
      )
    );
  }
}
