/// Represents a single completion record of a habit on a specific date.
class Completion {
  final int id;
  final int habitId;
  final DateTime completionDate;
  final DateTime createdAt;
  final int? progress; // Nullable for simple habits

  Completion({
    required this.id,
    required this.habitId,
    required this.completionDate,
    required this.createdAt,
    this.progress,
  });

  /// Creates a [Completion] from a JSON object (map).
  factory Completion.fromJson(Map<String, dynamic> json) {
    return Completion(
      id: json['id'],
      habitId: json['habit_id'],
      completionDate: DateTime.parse(json['completion_date']),
      createdAt: DateTime.parse(json['created_at']),
      progress: json['progress'],
    );
  }

  /// Converts this [Completion] object to a JSON object (map).
  Map<String, dynamic> toJson() {
    return {
      'habit_id': habitId,
      // Dates should be formatted as 'YYYY-MM-DD' for DATE type in PostgreSQL.
      'completion_date':
          '${completionDate.year}-${completionDate.month.toString().padLeft(2, '0')}-${completionDate.day.toString().padLeft(2, '0')}',
      'progress': progress,
    };
  }
}
