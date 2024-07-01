import 'dart:async';

import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'products.db';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        price INTEGER,
        stock INTEGER,
        imageUrl TEXT,
        categoryId INTEGER,
        createdAt TEXT,
        updatedAt TEXT,
        deletedAt TEXT
      )
    ''');
  }

  Future<int> insertProducts(List<Product> products) async {
    final db = await instance.database;
    int count = 0;
    Batch batch = db.batch();
    for (Product product in products) {
      batch.insert('products', product.toMap());
      count++;
    }
    await batch.commit();
    return count;
  }

  Future<List<Product>> getProducts(int limit, int offset) async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      limit: limit,
      offset: offset,
    );
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        price: maps[i]['price'],
        stock: maps[i]['stock'],
        imageUrl: maps[i]['imageUrl'],
        categoryId: maps[i]['categoryId'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
        updatedAt: DateTime.parse(maps[i]['updatedAt']),
        deletedAt: maps[i]['deletedAt'] != null ? DateTime.parse(maps[i]['deletedAt']) : null,
      );
    });
  }
}
