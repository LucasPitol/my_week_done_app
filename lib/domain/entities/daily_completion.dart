class DailyCompletion {
  const DailyCompletion({
    required this.id,
    required this.routineBlockId,
    required this.date,
    required this.completed,
    this.note,
  });

  final String id;
  final String routineBlockId;
  final DateTime date;
  final bool completed;
  final String? note;

  DailyCompletion copyWith({
    String? id,
    String? routineBlockId,
    DateTime? date,
    bool? completed,
    String? note,
  }) {
    return DailyCompletion(
      id: id ?? this.id,
      routineBlockId: routineBlockId ?? this.routineBlockId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      note: note ?? this.note,
    );
  }
}
