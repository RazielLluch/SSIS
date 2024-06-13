import 'model.dart';

class CourseModel extends Model{
  final String courseCode;
  final String name;

  CourseModel({required this.courseCode, required this.name});

  // Convert a Course object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'course_code': courseCode,
      'name': name,
    };
  }

  // Extract a Course object from a Map object
  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      courseCode: map['course_code'],
      name: map['name'],
    );
  }
}
