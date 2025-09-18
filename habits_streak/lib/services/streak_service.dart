import 'package:intl/intl.dart';
import '../data/models/habit_log.dart';

class StreakService {
  // Una racha cuenta días consecutivos con log >= mínimo
  int computeStreak(List<HabitLog> logs, {double minValue = 1}) {
    if (logs.isEmpty) return 0;
    final byDay = <String, HabitLog>{};
    final fmt = DateFormat('yyyy-MM-dd');

    for (final l in logs) {
      byDay[fmt.format(l.date)] = l;
    }

    var streak = 0;
    var day = DateTime.now();

    while (true) {
      final key = fmt.format(DateTime(day.year, day.month, day.day));
      final has = byDay[key]?.value ?? 0;
      if (has >= minValue) {
        streak += 1;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
