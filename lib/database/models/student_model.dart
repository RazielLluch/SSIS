import 'package:new_ssis_2/database/models/model.dart';

class StudentModel extends Model{
  final String id;
  final String name;
  final int? year;
  final String gender;
  final String? course;

  StudentModel({
    required this.id,
    required this.name,
    this.year,
    required this.gender,
    this.course,
  });

  // Convert a Student object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'gender': gender,
      'course': course,
    };
  }


  @override
  String toString() {
    return 'StudentModel{id: $id, name: $name, year: $year, gender: $gender, course: $course}';
  }

  factory StudentModel.fromSqfliteDatabase(Map<String, dynamic> map) => StudentModel(
    id: map['id'] ?? "",
    name: map['name'] ?? '',
    year: map['year']?.toInt() ?? '',
    gender: map['gender'] ?? '',
    course: map['course'] ?? '',
  );
}
