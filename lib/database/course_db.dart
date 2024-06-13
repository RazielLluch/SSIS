import 'package:new_ssis_2/database/student_db.dart';
import 'package:new_ssis_2/database/models/course_model.dart';
import 'package:sqflite/sqflite.dart';
import 'SsisDatabase.dart';

class CourseDB {
  final String tableName = "Courses";

  Future<void> createTable(Database database) async {
    // Create the Courses table
    await database.execute("""
    CREATE TABLE IF NOT EXISTS "Courses" (
      "courseCode" TEXT NOT NULL UNIQUE,
      "name" TEXT NOT NULL UNIQUE,
      PRIMARY KEY("courseCode")
    )
    """);

    // Create the Students table
    await StudentDB().createTable(database);

    // Create the trigger to update course_id to "not enrolled" on course deletion
    await database.execute("""
    CREATE TRIGGER IF NOT EXISTS update_student_course
    AFTER DELETE ON Courses
    FOR EACH ROW
    BEGIN
      UPDATE Students
      SET course = 'not enrolled'
      WHERE course = OLD.courseCode;
    END;
    """);
  }

  Future<int> create({required String courseCode, required String name}) async {
    final database = await SsisDatabase().database;
    return await database.rawInsert(
        '''INSERT INTO $tableName (courseCode, name) VALUES (?,?)''',
        [courseCode, name]
    );
  }

  Future<List<CourseModel>> fetchAll() async {
    final database = await SsisDatabase().database;
    final courses = await database.rawQuery('SELECT * FROM $tableName');
    return courses.map((course) => CourseModel.fromSqfliteDatabase(course)).toList();
  }

  Future<CourseModel> fetchById(String courseCode) async {
    final database = await SsisDatabase().database;
    final course = await database.rawQuery('SELECT * FROM $tableName WHERE courseCode = ?', [courseCode]);
    if (course.isNotEmpty) {
      return CourseModel.fromSqfliteDatabase(course.first);
    } else {
      throw Exception('Course not found');
    }
  }

  Future<List<CourseModel>> fetchBySearch(String searchQuery) async {
    final database = await SsisDatabase().database;
    final courses = await database.rawQuery(
        '''
      SELECT * FROM $tableName 
      WHERE courseCode LIKE ? 
         OR name LIKE ?
         
      ORDER BY courseCode ASC
      ''',
        ['%$searchQuery%', '%$searchQuery%']
    );
    return courses.map((course) => CourseModel.fromSqfliteDatabase(course)).toList();
  }

  Future<void> update({
    required String courseCode,
    String? newCourseCode,
    required String name,
  }) async {
    final database = await SsisDatabase().database;

    if (newCourseCode != null) {
      // Perform update by inserting a new row and deleting the old one
      await database.transaction((txn) async {
        // Insert new row
        await txn.rawInsert('''
          INSERT INTO $tableName (courseCode, name)
          VALUES (?, ?)
        ''', [newCourseCode, name]);

        // Delete old row
        await txn.rawDelete('''
          DELETE FROM $tableName WHERE courseCode = ?
        ''', [courseCode]);
      });
    } else {
      // Perform direct update with parameterized query
      await database.update(
        tableName,
        {
          'name': name,
        },
        where: 'courseCode = ?',
        whereArgs: [courseCode],
        conflictAlgorithm: ConflictAlgorithm.rollback, // Optional conflict algorithm
      );
    }
  }

  Future<void> delete(String courseCode) async {
    final database = await SsisDatabase().database;
    await database.rawDelete(
        '''DELETE FROM $tableName WHERE courseCode = ?''',
        [courseCode]
    );
  }
}
