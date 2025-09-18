import 'package:get/get.dart';
import '../../data/repos/habit_repo.dart';
import '../../data/models/habit.dart';
import '../../data/models/habit_log.dart';
import '../../services/streak_service.dart';

class HabitsController extends GetxController {
  final _repo = HabitRepo();
  final _streak = StreakService();

  final habits = <Habit>[].obs;
  final logsByHabit = <String, List<HabitLog>>{}.obs;
  final streakByHabit = <String, int>{}.obs;

  @override
  Future<void> onInit() async {
    await refreshAll();
    super.onInit();
  }

  Future<void> refreshAll() async {
    final h = await _repo.allHabits();
    habits.assignAll(h);
    for (final e in h) {
      final logs = await _repo.logsForHabit(e.id);
      logsByHabit[e.id] = logs;
      streakByHabit[e.id] = _streak.computeStreak(logs, minValue: 1);
    }
  }

  Future<void> addHabit(String title, {String goalType='bool', double goalValue=1}) async {
    await _repo.createHabit(title: title, goalType: goalType, goalValue: goalValue);
    await refreshAll();
  }

  Future<void> logToday(String habitId, {double value = 1}) async {
    await _repo.upsertLog(habitId: habitId, date: DateTime.now(), value: value);
    await refreshAll();
  }

  Future<void> removeHabit(String habitId) async {
    await _repo.deleteHabit(habitId);
    await refreshAll();
  }
}
