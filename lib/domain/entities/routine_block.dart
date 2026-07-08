class RoutineBlock {
  const RoutineBlock({
    required this.id,
    required this.weekday,
    required this.startTime,
    required this.title,
    this.category,
  });

  final String id;
  final int weekday;
  final DateTime startTime;
  final String title;
  final String? category;

  RoutineBlock copyWith({
    String? id,
    int? weekday,
    DateTime? startTime,
    String? title,
    String? category,
  }) {
    return RoutineBlock(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      startTime: startTime ?? this.startTime,
      title: title ?? this.title,
      category: category ?? this.category,
    );
  }
}
