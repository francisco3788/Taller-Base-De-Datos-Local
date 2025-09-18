import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDb {
  static final AppDb _i = AppDb._();
  AppDb._();
  factory AppDb() => _i;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'habits.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabla de hábitos
        await db.execute('''
          CREATE TABLE habits(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            goal_type TEXT NOT NULL,
            goal_value REAL NOT NULL,
            created_at TEXT NOT NULL
          );
        ''');

        // Registros diarios
        await db.execute('''
          CREATE TABLE habit_logs(
            id TEXT PRIMARY KEY,
            habit_id TEXT NOT NULL,
            date TEXT NOT NULL, -- ISO día
            value REAL NOT NULL,
            FOREIGN KEY(habit_id) REFERENCES habits(id) ON DELETE CASCADE
          );
        ''');

        // Unicidad por hábito+fecha
        await db.execute('''
          CREATE UNIQUE INDEX idx_habitlog_unique ON habit_logs(habit_id, date);
        ''');
      },
    );
  }
}
