

import 'package:new_ssis_2/database/SsisDatabase.dart';
import 'package:new_ssis_2/database/models/student_model.dart';
import 'package:sqflite/sqflite.dart';

class StudentDB{

  final tableName = "Students";

  Future<void> createTable(Database database) async{
    await database.execute("""
    CREATE TABLE IF NOT EXISTS "$tableName" (
      "id"	TEXT NOT NULL UNIQUE,
      "name"	TEXT NOT NULL,
      "year"	INTEGER,
      "gender"	TEXT NOT NULL,
      "course"	TEXT,
      FOREIGN KEY("course") REFERENCES "Courses"("id") ON UPDATE CASCADE,
      PRIMARY KEY("id")
    )
    """
    );
  }

  Future<int> create({required String id, required String name, int? year, required String gender, String? course}) async{
    final database = await SsisDatabase().database;
    return await database.rawInsert(
      ''' INSERT INTO $tableName (id, name, year, gender, course) VALUES (?,?,?,?,?)''',
      [id, name, year, gender, course]
    );
  }

  Future<List<StudentModel>> fetchAll() async{
    final database = await SsisDatabase().database;
    final students = await database.rawQuery(
      '''SELECT *  FROM $tableName'''
    );
    return students.map((student) => StudentModel.fromSqfliteDatabase(student)).toList();
  }

  Future<StudentModel> fetchById(String id)async{
    final database = await SsisDatabase().database;
    final student = await database.rawQuery(
        '''SELECT * FROM $tableName WHERE id = ?''',
        [id]
    );
    return StudentModel.fromSqfliteDatabase(student.first);
  }

  Future<List<StudentModel>> fetchBySearch(String searchQuery) async {
    final database = await SsisDatabase().database;
    final students = await database.rawQuery('''
      SELECT * FROM $tableName 
      WHERE id LIKE '%$searchQuery%' 
         OR name LIKE '%$searchQuery%' 
         OR year LIKE '%$searchQuery%' 
         OR gender LIKE '%$searchQuery%' 
         OR course LIKE '%$searchQuery%';
      ORDER BY id ASC
    ''');
    List<StudentModel> data = students.map((student) => StudentModel.fromSqfliteDatabase(student)).toList();
    print("this is your fetch by search data: $data");
    return data;
  }

  Future<void> update({
    required String id,
    String? newId,
    required String name,
    int? year,
    required String gender,
    String? course,
  }) async {
    final database = await SsisDatabase().database;

    if (newId != null) {
      // Perform update by inserting a new row and deleting the old one
      await database.transaction((txn) async {
        // Insert new row
        await txn.rawInsert('''
          INSERT INTO $tableName (id, name, year, gender, course)
          VALUES (?, ?, ?, ?, ?)
        ''', [newId, name, year, gender, course]);

        // Delete old row
        await txn.rawDelete('''
          DELETE FROM $tableName WHERE id = ?
        ''', [id]);
      });
    } else {
      // Perform direct update with parameterized query
      await database.update(
        tableName,
        {
          'name': name,
          if (year != null) 'year': year,
          'gender': gender,
          if (course != null) 'course': course,
        },
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.rollback, // Optional conflict algorithm
      );
    }
  }

  Future<void> delete(String id)async{
    final database = await SsisDatabase().database;
    await database.rawDelete(
        '''DELETE FROM $tableName WHERE id = ?''',
        [id]
    );
  }
}