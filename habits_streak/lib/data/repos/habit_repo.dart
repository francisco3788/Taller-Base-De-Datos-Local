import 'package:uuid/uuid.dart';
import '../db/app_db.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import 'package:sqflite/sqflite.dart';


class HabitRepo {
  final _uuid = const Uuid();

  Future<List<Habit>> allHabits() async {
    final db = await AppDb().database;
    final rows = await db.query('habits', orderBy: 'created_at DESC');
    return rows.map(Habit.fromMap).toList();
  }

  Future<String> createHabit({
    required String title,
    required String goalType,
    required double goalValue,
  }) async {
    final db = await AppDb().database;
    final id = _uuid.v4();
    await db.insert('habits', Habit(
      id: id,
      title: title,
      goalType: goalType,
      goalValue: goalValue,
      createdAt: DateTime.now(),
    ).toMap());
    return id;
  }

  Future<void> deleteHabit(String id) async {
    final db = await AppDb().database;
    await db.delete('habits', where: 'id=?', whereArgs: [id]);
  }

  // Logs
  Future<void> upsertLog({
    required String habitId,
    required DateTime date,
    required double value,
  }) async {
    final db = await AppDb().database;
    final log = HabitLog(id: _uuid.v4(), habitId: habitId, date: date, value: value);
    await db.insert('habit_logs', log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HabitLog>> logsForHabit(String habitId) async {
    final db = await AppDb().database;
    final rows = await db.query('habit_logs',
      where: 'habit_id=?',
      whereArgs: [habitId],
      orderBy: 'date DESC');
    return rows.map(HabitLog.fromMap).toList();
  }
}
