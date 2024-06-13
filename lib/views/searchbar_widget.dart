import 'package:flutter/material.dart';
import 'package:new_ssis_2/controllers/search_controller.dart';
import 'package:new_ssis_2/handlers/searching_handler.dart';
import 'package:new_ssis_2/misc/scope.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  Scope? searchScope;
  late String searchQuery;

  SearchHandler searchHandler = SearchHandler();
  late SearchingController searchingController;

  @override
  void initState(){
    searchQuery = _searchController.text;
    searchingController = context.read<SearchingController>(); // Initialize the controller
    searchingController.initialize();
    super.initState();
  }

  void _search(String query) async{
    await searchingController.search(query, searchScope!);
    setState(() {
      print("searching \"$query\" in $searchScope");
    });
  }

  @override
  Widget build(BuildContext context) {

    print("new searchbar state");

    searchQuery = _searchController.text;
    print("search query is currently $searchQuery");


    if(searchScope != null){
      _search(searchQuery);
    }else{
      // searchingController.initialize();
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[ // Search icon
          const SizedBox(width: 8.0),
          Tooltip(
            message: 'search student',
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (searchScope == Scope.student) {
                      return Colors.lightBlueAccent; // Set the background color when pressed
                    }
                    return Colors.grey; // Set the default background color
                  },
                ),
              ),
              onPressed: () {
                if(searchScope != Scope.student){
                  print("setting scope to ${Scope.student}");
                  searchScope = Scope.student;
                  _search(searchQuery);
                }else{
                  print("setting scope to null");
                  searchScope = null;
                  setState(() {

                  });
                }

                print("searchScope: $searchScope \n");

              },
              child: Icon(
                Icons.person,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Tooltip(
            message: 'search course',
            child:ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (searchScope == Scope.course) {
                      return Colors.lightBlueAccent; // Set the background color when pressed
                    }
                    return Colors.grey; // Set the default background color
                  },
                ),
              ),
              onPressed: () {
                if(searchScope != Scope.course){
                  print("setting scope to ${Scope.course}");
                  searchScope = Scope.course;
                  _search(searchQuery);
                }else{
                  print("setting scope to null");
                  searchScope = null;
                  setState(() {

                  });
                }

                print("searchScope: $searchScope \n");

              },

              child: Icon(
                Icons.menu_book,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          const Icon(Icons.search),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: _searchController, // Search input field
              decoration: const InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: (text){
                searchQuery = text;
                if(searchScope != null){
                  _search(text);
                }
              },
            ),  // Search Text Field
          ),
          IconButton(
            padding: const EdgeInsets.only(bottom: 0.5),
            alignment: Alignment.center,
            iconSize: 15,
            icon: Icon(
              Icons.clear,
              color: Colors.grey.shade800,
            ), // X button to clear the search input field
            onPressed: () {

              _searchController.clear();
              searchQuery = _searchController.text;
              searchScope = Scope.student;
              _search(searchQuery);
              searchScope = Scope.course;
              _search(searchQuery);
              searchScope = null;


              // setState(() {
              //   _searchController.clear();
              //
              //   _search(searchQuery);
              // });
            },
          ), // Reset search button
        ],
      ),
    );
  }
}
