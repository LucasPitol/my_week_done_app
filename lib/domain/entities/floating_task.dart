class FloatingTask {
  const FloatingTask({
    required this.id,
    required this.title,
    this.category,
    this.deadline,
    required this.completed,
    this.completedAt,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? category;
  final DateTime? deadline;
  final bool completed;
  final DateTime? completedAt;
  final DateTime createdAt;

  FloatingTask copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? deadline,
    bool clearDeadline = false,
    bool? completed,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    DateTime? createdAt,
  }) {
    return FloatingTask(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      completed: completed ?? this.completed,
      completedAt:
          clearCompletedAt ? null : (completedAt ?? this.completedAt),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
