import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verzel/app/shared/models/task_model.dart';
import 'package:verzel/app/shared/utils/database.dart';

class TaskRepository extends Disposable {
  static final _table = "tasks";

  Future<Database> _database() {
    return DatabaseHelper.instance.database;
  }

  // * Insere task no banco de dados
  Future<int> insert(TaskModel row) async {
    final Database db = await _database();
    try {
      return await db.insert(_table, row.toMap());
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Lista todos as tasks
  Future<List<TaskModel>> queryAllRows() async {
    final Database db = await _database();
    try {
      final users = await db.query(_table);

      return users.map((e) => TaskModel.fromMap(e)).toList();
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Lista todas tasks
  Future<List<TaskModel>> getTasksUser(int id) async {
    final Database db = await _database();
    try {
      final users =
          await db.query(_table, where: 'user_id = ?', whereArgs: [id]);

      return users.map((e) => TaskModel.fromMap(e)).toList();
    } catch (error) {
      print(error);
    }
    return null;
  }

  /// * Retorna a quantidade registros
  Future<int> queryRowCount() async {
    final Database db = await _database();
    try {
      return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $_table'));
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Atualiza a task
  Future<int> update(TaskModel row) async {
    final Database db = await _database();
    try {
      return await db
          .update(_table, row.toMap(), where: 'id = ?', whereArgs: [row.id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Delete a task
  Future<int> delete(int id) async {
    final Database db = await _database();
    try {
      return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Busca a task pelo id
  Future<TaskModel> findById(int id) async {
    final Database db = await _database();
    try {
      List<Map<String, dynamic>> maps = await db.query("$_table",
          // columns: ["id", "name", "date_modification", "date_create"],
          where: 'id = ?',
          whereArgs: [id]);

      if (maps.first.length > 0) {
        return TaskModel.fromMap(maps.first);
      }
    } catch (error) {
      print(error);
    }

    return null;
  }

  @override
  void dispose() {}
}
