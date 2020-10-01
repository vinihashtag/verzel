import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verzel/app/shared/utils/enums.dart';

class DatabaseHelper {
// * Torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // * tem somente uma referência ao banco de dados
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // * instancia o db na primeira vez que for acessado
    _database = await _initDatabase();
    return _database;
  }

  // * abre o banco de dados e o cria se ele não existir
  static _initDatabase() async {
    try {
      String path = join(
          await getDatabasesPath(), DatabaseHelperEnum.getValue(DATABASE.name));
      // await deleteDatabase(path);
      return await openDatabase(path,
          version: DatabaseHelperEnum.getValue(DATABASE.version),
          onCreate: _onCreate,
          onConfigure: _onConfigure);
    } catch (error) {
      print(error);
    }
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    print('Foreign keys turned on');
  }

  // * Código SQL para criar o banco de dados e a tabela
  static Future _onCreate(Database db, int version) async {
    var sql = [
      // '''DROP TABLE IF EXISTS users;''',
      // '''DROP TABLE IF EXISTS tasks;''',
      '''create table if not exists users (
            id integer primary key autoincrement,
            nome text,
            email text,
            data_nascimento text,
            cpf text,
            cep text,
            endereco text,
            numero text,
            senha text
            );''',
      '''create table if not exists tasks (
            id integer primary key autoincrement,
            nome text,
            data_entrega text,
            data_conclusao text,
            finalizado text,
            user_id int NOT NULL,
            foreign key (user_id) references users (id) ON DELETE CASCADE
            );''',
    ];

    for (var i = 0; i < sql.length; i++) {
      // print("execute sql : " + sql[i]);
      await db.execute(sql[i]).catchError((onError) => print(onError));
    }
  }
}
