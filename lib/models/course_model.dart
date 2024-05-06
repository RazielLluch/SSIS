class Course{
  late String _courseName;
  late String _courseCode;

  Course(String courseName, String courseCode){
    setCourseName(courseName);
    setCourseCode(courseCode);
  }

  void setCourseName(String courseName){
    _courseName = courseName;
  }

  void setCourseCode(String courseCode){
    _courseCode = courseCode;
  }

  String getCourseName(){
    return _courseName;
  }

  String getCourseCode(){
    return _courseCode;
  }
}