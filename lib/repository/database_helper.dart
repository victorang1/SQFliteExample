import 'package:flutter_crud_example/model/book.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager _instance = new DatabaseManager.internal();

  factory DatabaseManager() => _instance;

  final String tableName = 'Book';

  static Database _db;

  DatabaseManager.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'crud.db');
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE $tableName('+
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'+
          'title TEXT)'
      );
    });
  }

  Future<int> saveTitle(Book item) async {
    var dbClient = await db;
    var result = await dbClient.insert('Book', item.toMap());
    return result;
  }

  Future<List<Book>> getAllTitle() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');
    List<Book> list = result.isNotEmpty ? result.map((item) => Book.fromMap(item)).toList() : [];
    return list;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT (*) FROM Book'));
  }

  Future<int> deleteBook(int id) async {
    var dbClient = await db;
    return await dbClient.delete('Book', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateBook(Book book) async {
    var dbClient = await db;
    return await dbClient.update('Book', book.toMap(),
        where: 'id = ?', whereArgs: [book.getId]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
