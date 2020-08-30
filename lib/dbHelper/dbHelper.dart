import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // commnly used variables
  static final _dbName = 'favDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = 'myfavTable';

  // for table column
  static final columnId = '_id';
  static final columnQuote = 'quote';
  static final columnAuthor = 'author';

  // Making Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // getting instance of db from sqflite
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute(''' 
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnQuote TEXT NOT NULL,
      $columnAuthor TEXT NOT NULL )
      
       ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(
      _tableName,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
