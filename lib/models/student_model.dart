import 'course_model.dart';

class Student{
  late String _studentName;
  late String _studentId;
  int? _yearLvl;
  late String _gender;
  Course? _course;

  Student(String name, String id, int? yearlvl, String gender, String? course){
    setName(name);
    setId(id);
    setYearLevel(yearlvl);
    setGender(gender);
    setCourse(course);
  }

  void setName(String name){
    _studentName = name;
  }

  void setId(String id){
    _studentId = id;
  }

  void setYearLevel(int? year){
    _yearLvl = year;
  }

  void setGender(String gender){
    _gender = gender;
  }

  void setCourse(String? course){

    //finish course handler first

    // _course = course.getCourseCode();
  }

  String getName(){
    return _studentName;
  }

  String getId(){
    return _studentId;
  }

  int? getYear(){
    return _yearLvl;
  }

  String getGender(){
    return _gender;
  }

  Course? getCourse(){
    return _course;
  }
}