class HabitLog {
  final String id;         // uuid
  final String habitId;    // fk
  final DateTime date;     // sólo fecha (YYYY-MM-DD)
  final double value;      // 1, 8, 30

  HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.value,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'habit_id': habitId,
    'date': DateTime(date.year, date.month, date.day).toIso8601String(),
    'value': value,
  };

  static HabitLog fromMap(Map<String, dynamic> m) => HabitLog(
    id: m['id'] as String,
    habitId: m['habit_id'] as String,
    date: DateTime.parse(m['date'] as String),
    value: (m['value'] as num).toDouble(),
  );
}
