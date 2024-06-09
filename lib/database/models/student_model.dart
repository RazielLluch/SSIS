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

  // Extract a Student object from a Map object
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
      year: map['year'],
      gender: map['gender'],
      course: map['course'],
    );
  }
}
