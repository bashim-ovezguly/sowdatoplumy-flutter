import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

void setLocalStorage(key, value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getLocalStorage(key) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.getString(key);
}

class DatabaseSQL {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 2;

  static const table = 'my_table';
  static const table1 = 'my_table1';
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnPassword = 'password';
  static const columnUserId = 'userId';
  static const shoping_cart = 'shoping_cart';
  static const shoping_cart_items = 'shoping_cart_items';
  late final Database _db;

  Future<void> init() async {
    final documetsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documetsDirectory.path, _databaseName);
    _db =
        await openDatabase(path, version: _databaseVersion, onCreate: _onCreate,
            onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion == 1) {
        await db.execute('''
          CREATE TABLE $shoping_cart (
            id INTEGER PRIMARY KEY,
            store_id INTEGER NOT NULL,
            customer_id INTEGER NOT NULL
          )''');

        await db.execute('''
          CREATE TABLE $shoping_cart_items (
            id INTEGER PRIMARY KEY,
            soping_cart_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            count INTEGER NOT NULL DEFAULT 0         
          )''');
      }
    });
  }

  // user table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnUserId INTEGER
          )
          ''');

    //
    await db.execute('''
          CREATE TABLE $table1 (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $shoping_cart (
            id INTEGER PRIMARY KEY,
            store_id INTEGER NOT NULL)''');

    await db.execute('''
          CREATE TABLE $shoping_cart_items (
            id INTEGER PRIMARY KEY,
            soping_cart_id INTEGER NOT NULL,
            product_img TEXT,
            product_name TEXT,
            product_price TEXT,
            product_id INTEGER NOT NULL,
            count INTEGER NOT NULL DEFAULT 0)''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    await _db.insert(table, row);
    return 0;
  }

  Future<int> inser1(Map<String, dynamic> row) async {
    await _db.insert(table1, row);
    return 0;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.rawQuery('SELECT * FROM "my_table"');
  }

  Future<List<Map<String, dynamic>>> get_shoping_cart_by_store(
      {required String id}) async {
    return await _db.rawQuery('SELECT * FROM shoping_cart where store_id=$id');
  }

  Future<List<Map<String, dynamic>>> get_shoping_cart_item(
      {required String soping_cart_id, required String product_id}) async {
    return await _db.rawQuery(
        'SELECT * FROM shoping_cart_items where soping_cart_id=$soping_cart_id and product_id=$product_id');
  }

  Future<List<Map<String, dynamic>>> get_shoping_cart_items(
      {required String soping_cart_id}) async {
    return await _db.rawQuery(
        'SELECT * FROM shoping_cart_items where soping_cart_id=$soping_cart_id');
  }

  Future<int> product_count_increment(
      {required String item_id, required int count}) async {
    return await _db.rawUpdate(
        'UPDATE shoping_cart_items SET count=$count where id=$item_id');
  }

  Future<int> delete_item({required String item_id}) async {
    return await _db
        .rawDelete('DELETE FROM shoping_cart_items where id=$item_id');
  }

  Future<int> delete_shoping_cart_items({required int shoping_cart_id}) async {
    return await _db.rawDelete(
        'DELETE FROM shoping_cart_items where soping_cart_id=$shoping_cart_id');
  }

  Future<int> shoping_cart_inser(Map<String, dynamic> row) async {
    await _db.insert(shoping_cart, row);
    return 0;
  }

  Future<int> add_product_shoping_cart(Map<String, dynamic> row) async {
    print('ergjnern');
    await _db.insert(shoping_cart_items, row);
    return 0;
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

  Future<List<Map<String, dynamic>>> getItem({required int id}) async {
    return await _db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }
}
