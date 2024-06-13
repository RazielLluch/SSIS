import 'model.dart';

class CourseModel extends Model{
  final String courseCode;
  final String name;

  CourseModel({required this.courseCode, required this.name});

  // Convert a Course object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'name': name,
    };
  }


  @override
  String toString() {
    return 'CourseModel{courseCode: $courseCode, name: $name}';
  } // Extract a Course object from a Map object
  factory CourseModel.fromSqfliteDatabase(Map<String, dynamic> map) => CourseModel(
    courseCode: map['courseCode'] ?? "",
    name: map['name'] ?? '',
  );
}
