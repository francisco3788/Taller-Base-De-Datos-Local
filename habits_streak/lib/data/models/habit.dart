class Habit {
  final String id;        
  final String title;     
  final String goalType;  
  final double goalValue; 
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.title,
    required this.goalType,
    required this.goalValue,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'goal_type': goalType,
    'goal_value': goalValue,
    'created_at': createdAt.toIso8601String(),
  };

  static Habit fromMap(Map<String, dynamic> m) => Habit(
    id: m['id'] as String,
    title: m['title'] as String,
    goalType: m['goal_type'] as String,
    goalValue: (m['goal_value'] as num).toDouble(),
    createdAt: DateTime.parse(m['created_at'] as String),
  );
}
