class HabitLog {
  final String id;         
  final String habitId;    
  final DateTime date;     
  final double value;      

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
