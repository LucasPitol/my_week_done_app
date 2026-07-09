class RoutineBlock {
  const RoutineBlock({
    required this.id,
    required this.weekday,
    required this.startTime,
    required this.title,
    this.category,
    this.groupId,
  });

  final String id;
  final int weekday;
  final DateTime startTime;
  final String title;
  final String? category;

  /// Vincula blocos criados juntos (ex.: mesma rotina em ter/qua/sex).
  final String? groupId;

  RoutineBlock copyWith({
    String? id,
    int? weekday,
    DateTime? startTime,
    String? title,
    String? category,
    String? groupId,
    bool clearGroupId = false,
  }) {
    return RoutineBlock(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      startTime: startTime ?? this.startTime,
      title: title ?? this.title,
      category: category ?? this.category,
      groupId: clearGroupId ? null : (groupId ?? this.groupId),
    );
  }
}
