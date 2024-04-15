import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:eudaimonia_bakery/models/menu.dart';
class DbHelper {
  static Future<Database> _database() async {
    sqfliteFfiInit(); // Initialize sqflite_ffi
    final database =
        openDatabase(join(await getDatabasesPath(), 'eudaimonia.db'),
            onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE menus (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, price INTEGER)');
    }, version: 1);

    return database;
  }

  // insert new menu to database
  static insert({required Menu menu}) async {
    final db = await _database();

    await db.insert(
      'menus',
      menu.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // get all data menu from database
  static Future<List<Menu>> getMenus() async {
    final db = await _database();

    final List<Map<String, dynamic>> maps = await db.query('menus');

    return List.generate(maps.length, (index) {
      return Menu(
        id: maps[index]['id'] as int,
        title: maps[index]['title'] as String,
        description: maps[index]['description'] as String,
        price: maps[index]['price'] as int,
      );
    });
  }

  // update menu by id
  static updateMenu({required Menu menu}) async {
    final db = await _database();

    await db
        .update('menus', menu.toMap(), where: "id = ?", whereArgs: [menu.id]);
  }

  // delete all menu
  static Future<void> deleteAllMenus() async {
    final db = await _database();

    await db.delete('menus');
  }

  // delete menu by id
  static delete({required Menu menu}) async {
    final db = await _database();

    await db.delete('menus', where: "id = ?", whereArgs: [menu.id]);
  }
}
