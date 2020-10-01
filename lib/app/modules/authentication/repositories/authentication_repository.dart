import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verzel/app/shared/models/user_model.dart';
import 'package:verzel/app/shared/utils/database.dart';

class AuthenticationRepository extends Disposable {
  static final _table = "users";

  Future<Database> _database() {
    return DatabaseHelper.instance.database;
  }

  // * Insere usuário no banco de dados
  Future<int> insert(UserModel row) async {
    final Database db = await _database();
    try {
      return await db.insert(_table, row.toMap());
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Lista todos os usuários
  Future<List<UserModel>> queryAllRows() async {
    final Database db = await _database();
    try {
      final users = await db.query(_table);

      return users.map((e) => UserModel.fromMap(e)).toList();
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

  // * Atualiza o usuário
  Future<int> update(UserModel row) async {
    final Database db = await _database();
    try {
      return await db
          .update(_table, row.toMap(), where: 'id = ?', whereArgs: [row.id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Delete o usuário
  Future<int> delete(id) async {
    final Database db = await _database();
    try {
      return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Busca o usuário pelo id
  Future<UserModel> findById(int id) async {
    final Database db = await _database();
    try {
      List<Map<String, dynamic>> maps = await db.query("$_table",
          // columns: ["id", "name", "date_modification", "date_create"],
          where: 'id = ?',
          whereArgs: [id]);

      if (maps.first.length > 0) {
        return UserModel.fromMap(maps.first);
      }
    } catch (error) {
      print(error);
    }

    return null;
  }

  // * Busca o usuário pelo email
  Future<UserModel> findByEmail(String email) async {
    final Database db = await _database();
    try {
      List<Map<String, dynamic>> maps = await db.query("$_table",
          // columns: ["id", "nome", "date_modification", "date_create"],
          where: 'email = ?',
          whereArgs: [email]);

      if (maps.first.length > 0) {
        return UserModel.fromMap(maps.first);
      }
    } catch (error) {
      print(error);
    }

    return null;
  }

  @override
  void dispose() {}
}
