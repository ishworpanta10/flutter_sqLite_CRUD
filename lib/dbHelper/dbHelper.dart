import 'dart:io';
import 'package:flutterdbDemo/Model/quote.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // commnly used variables
  static final _dbName = 'favDatabase.db';
  static final _dbVersion = 1;

  // Making Singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // getting instance of db from sqflite
  static Database _database;

// getter for db
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initiateDatabase();
    return _database;
  }

  // initiate db for for time that app run
  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbpath = join(directory.path, _dbName);
    return await openDatabase(dbpath, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    // creating table
    db.execute(''' 
      CREATE TABLE ${Quote.tableName}(
      ${Quote.columnId} INTEGER PRIMARY KEY,
      ${Quote.columnQuote} TEXT NOT NULL,
      ${Quote.columnAuthor} TEXT NOT NULL,
      ${Quote.columnisFav} INTEGER NOT NULL )
      
       ''');
  }

  // insert
  Future<int> insert(Quote quote) async {
    Database db = await instance.database;
    return await db.insert(Quote.tableName, quote.toMap());
  }

  // Read
  Future<List<Quote>> queryAll() async {
    Database db = await instance.database;
    List<Map> quote = await db.query(Quote.tableName);
    return quote.length == 0 ? [] : quote.map((e) => Quote.fromMap(e)).toList();
  }

  // update
  Future<int> update(Quote quote) async {
    Database db = await instance.database;
    return await db.update(
      Quote.tableName,
      quote.toMap(),
      where: '${Quote.columnId} = ?',
      whereArgs: [quote.id],
    );
  }

  // Delete
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      Quote.tableName,
      where: '${Quote.columnId} = ?',
      whereArgs: [id],
    );
  }

  // filter by author
  Future<List<Quote>> filterbyAuthorAll(String author) async {
    Database db = await instance.database;
    List<Map> quote = await db.query(
      Quote.tableName,
      where: '${Quote.columnAuthor} = ?',
      whereArgs: [author],
    );
    return quote.length == 0 ? [] : quote.map((e) => Quote.fromMap(e)).toList();
  }

  //filter by isFav
  Future<List<Quote>> filterbyFav(int isFav) async {
    Database db = await instance.database;
    List<Map> quote = await db.query(
      Quote.tableName,
      where: '${Quote.columnisFav} = ?',
      whereArgs: [isFav],
    );
    return quote.length == 0 ? [] : quote.map((e) => Quote.fromMap(e)).toList();
  }
}
