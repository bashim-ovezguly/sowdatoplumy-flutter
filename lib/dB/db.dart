import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseSQL {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';
  static const table1 = 'my_table1';
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnPassword = 'age';
  static const columnUserId = 'userId';
  late final Database _db;



  Future <void> init() async {
    final documetsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documetsDirectory.path, _databaseName);
    _db = await openDatabase(
        path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnUserId INTEGER
          )
          ''');

    await db.execute('''
          CREATE TABLE $table1 (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

    Future<int> insert(Map<String, dynamic> row) async{
      await _db.insert(table, row);
      return 0;
    }
    Future<int> inser1(Map<String, dynamic> row) async{
      await _db.insert(table1, row);
      return 0;
    }


    Future<List<Map<String, dynamic>>> queryAllRows() async {
      return await _db.rawQuery('SELECT * FROM "my_table"');
    }

    Future<List<Map<String, dynamic>>> queryAllRows1() async {
      return await _db.rawQuery('SELECT * FROM "my_table1"');
    }

    Future<int> deleteAllRows() async {
      return await _db.delete(table);
    }
    Future<int> deleteAllRows1() async {
      return await _db.delete(table1);
    }
    

    Future<List<Map<String, dynamic>>> getItem( {required int id }) async {
    return await _db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
    
  }
}