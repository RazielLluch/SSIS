import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/course_model.dart';
import 'models/student_model.dart';

class SsisDatabase {
  static final SsisDatabase _instance = SsisDatabase._internal();
  factory SsisDatabase() => _instance;
  static Database? _database;

  SsisDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'school.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Courses (
        course_code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL UNIQUE,
        PRIMARY KEY(course_code)
      )
    ''');

    await db.execute('''
      CREATE TABLE Students (
        id TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        year INTEGER,
        gender TEXT NOT NULL,
        course TEXT,
        PRIMARY KEY(id),
        FOREIGN KEY(course) REFERENCES Courses(course_code) ON DELETE SET NULL
      )
    ''');
  }

  // CRUD operations for Courses
  Future<int> insertCourse(CourseModel course) async {
    final db = await database;
    return await db.insert('Courses', course.toMap());
  }

  Future<List<CourseModel>> getCourses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Courses');
    return List.generate(maps.length, (i) {
      return CourseModel.fromMap(maps[i]);
    });
  }

  Future<int> updateCourse(CourseModel course) async {
    final db = await database;
    return await db.update(
      'Courses',
      course.toMap(),
      where: 'course_code = ?',
      whereArgs: [course.courseCode],
    );
  }

  Future<int> deleteCourse(String courseCode) async {
    final db = await database;
    return await db.delete(
      'Courses',
      where: 'course_code = ?',
      whereArgs: [courseCode],
    );
  }

  // CRUD operations for Students
  Future<int> insertStudent(StudentModel student) async {
    final db = await database;
    return await db.insert('Students', student.toMap());
  }

  Future<List<StudentModel>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Students');
    return List.generate(maps.length, (i) {
      return StudentModel.fromMap(maps[i]);
    });
  }

  Future<int> updateStudent(StudentModel student) async {
    final db = await database;
    return await db.update(
      'Students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(String id) async {
    final db = await database;
    return await db.delete(
      'Students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
