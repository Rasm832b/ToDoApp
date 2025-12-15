import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseController {
  static final DatabaseController _instance = DatabaseController._internal();

  factory DatabaseController() => _instance;

  DatabaseController._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'database.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Todo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task TEXT,
            priority INTEGER NOT NULL CHECK (priority BETWEEN 0 AND 2),
            state BOOLEAN NOT NULL DEFAULT FALSE
          )
        ''');
        await db.insert('Todo', {'task': 'tester noget', 'priority': 1});
        await db.insert('Todo', {'task': 'tester nogt', 'priority': 2});
        await db.insert('Todo', {'task': 'tester net', 'priority': 0});
      },
    );
    print('Database initialized');
    return db;
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await database;
    return await db.query('Todo');
  }

  Future<int> insertTodo(String task, int priority) async {
    final db = await database;
    return await db.insert('Todo', {'task': task, 'priority': priority});
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('Todo', where: 'id = ?', whereArgs: [id]);
  }
}
