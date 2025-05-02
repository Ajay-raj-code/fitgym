import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = "mydb.db";
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, dbName);

    bool exists = await databaseExists(dbPath);
    if (!exists) {
      ByteData data = await rootBundle.load("assets/database/$dbName");
      List<int> bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(dbPath);
  }
   Future<List<Map<String, Object?>>> getData(String table) async{
    final db = await getDatabase();

    return await db.query(table);
  }
   Future<List<Map<String, dynamic>>> getFilteredExercises(int id_type) async {
    final db = await getDatabase();
    return await db.query(
      'exercise',
      where: 'id_type = ?',
      whereArgs: [id_type],
    );
  }
  Future<int?> getMaxExerciseId() async {
    final db = await getDatabase();
    var result = await db.rawQuery('SELECT MAX(id_exercise) as maxId FROM exercise');
    return result.first['maxId'] as int?;
  }
  Future<void> insertCustomExercise({required int id_type, required String name, required String descreption, required int custom, required int id_exercise}) async {
    final db = await getDatabase();
    await db.insert(
      'exercise',  // Table name
      {
        'id_type': id_type,
        'name': name,
        'text': descreption,
        'custom': custom,
        'id_exercise':id_exercise,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertCustomImage({required String name, required int number, required int id_exercise}) async {
    final db = await getDatabase();
    await db.insert(
      'extra_image',  // Table name
      {
        'name': name,
        'number': number,
        'id_exercise':id_exercise,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertExerciseHistory({required String date, required int id_exercise, required double weight, required int reps }) async{
    final db = await getDatabase();
    await db.insert(
      'exercise_history',  // Table name
      {
        'date': date,
        'id_exercise': id_exercise,
        'weight':weight,
        "reps":reps,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Map<String, dynamic>>> getFilteredExercisesHistory(int id_type) async {
    final db = await getDatabase();
    return await db.query(
      'exercise_history',
      where: 'id_exercise = ?',
      whereArgs: [id_type],
    );
  }
  
  Future<void> updateExerciseHistory({required int id,required double weight,required int reps}) async {
    final db = await getDatabase();
    await db.update('exercise_history',
      {'weight': weight, "reps":reps}, // updated values
      where: 'id = ?', // where clause
      whereArgs: [id],
    );
  }
  Future<void> insertPlanCategory({ required String name,  required int custom, required int totalDays}) async {
    final db = await getDatabase();
    await db.insert(
      'exercise_plans_category',  // Table name
      {
        'name': name,
         'custom': custom,
        'total_days':totalDays,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPlanList({ required int day,  required int sets, required List<int> id_exercises, required int id_exercise_category}) async {
    final db = await getDatabase();
    Batch batch = db.batch();

    for(var exercise_id in id_exercises){
      batch.insert('exercise_plan_list', {
        'day':day,
        'sets':sets,
        'id_exercise':exercise_id,
        'id_exercise_cat':id_exercise_category,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getLastRowOfPlansCategory() async {
    final db = await getDatabase();
    return  await db.rawQuery(
        'SELECT * FROM exercise_plans_category ORDER BY id DESC LIMIT 1'
    );
  }

  Future<List<Map<String, dynamic>>> getFilteredExercisesPlanList({required int exerciseCat}) async {
    final db = await getDatabase();
    return await db.query(
      'exercise_plan_list',
      where: 'id_exercise_cat = ?',
      whereArgs: [exerciseCat],
    );
  }
  Future<void> deletePlansExerciseList({required int day, required int id_exercise, required int id_exercise_cat}) async{
    final db = await getDatabase();
    await db.delete("exercise_plan_list", where: 'day = ? AND id_exercise = ? AND id_exercise_cat = ?', whereArgs: [day, id_exercise, id_exercise_cat],);
  }

  Future<void> deletePlansCategory({required int id}) async{
    final db = await getDatabase();
    await db.delete("exercise_plans_category" ,where: 'id = ?', whereArgs: [id]);
  }
  Future<void> deletePlansExercise({required int id}) async{
    final db = await getDatabase();
    await db.delete("exercise_plan_list" ,where: 'id_exercise_cat = ?', whereArgs: [id]);
  }
}