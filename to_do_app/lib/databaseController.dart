import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

Future<Database> initDB() async {
  var db = await openDatabase(
    'database.db',
    version: 1,
    onCreate: (Database db, version) async {
      await db.execute(
        'CREATE TABLE Todo (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, priority INTEGER NOT NULL CHECK (priority BETWEEN 1 AND 3))',
      );
      await db.insert('Todo', {'task': 'tester noget', 'priority': 3});
    },
  );
  print('DB initialized');
  return db;
}
