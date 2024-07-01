import 'dart:convert';

import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/secure_storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "user_database.db";
  static const _databaseVersion = 1;
  static const _tableName = "users";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        user_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        role TEXT,
        phone_number TEXT,
        address TEXT,
        created_at TEXT,
        updated_at TEXT,
        deleted_at TEXT
      )
    ''');
  }

  // Insert or Update User
  Future<void> insertOrUpdateUser(User user) async {
    Database db = await instance.database;
    int updated = await db.update(_tableName, user.toMap(), where: 'user_id = ?', whereArgs: [user.userId]);
    if (updated == 0) {
      await db.insert(_tableName, user.toMap());
    }
  }

  // Get User
  Future<User?> getUser() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(_tableName, limit: 1); 
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first); 
    } else {
      return null; 
    }
  }

  // Delete User (Optional)
  Future<int> deleteUser() async {
    Database db = await instance.database;
    return await db.delete(_tableName); // Deletes all users, you can add conditions if needed
  }

    // ! Sync User Data with API
  Future<void> syncUserData(User user) async {
    // Update SQLite
    await insertOrUpdateUser(user);

    // Retrieve token from secure storage
    final tokenAccess = await SecureStorageUtil.storage.read(key: tokenStoreName);
    print(tokenAccess);
    if (tokenAccess == null) {
      throw Exception('No authentication token found');
    }

    // Update API
    final response = await http.put(
      Uri.parse(Endpoints.syncUserData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenAccess',
      },
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user data');
    }
  }

}