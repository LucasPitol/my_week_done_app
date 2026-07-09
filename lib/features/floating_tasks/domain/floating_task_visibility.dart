import '../../../data/mappers/routine_mappers.dart';
import '../../../domain/entities/floating_task.dart';

enum FloatingTaskDeadlineUrgency { none, dueToday, overdue }

bool isFloatingTaskVisible(FloatingTask task, DateTime viewDate) {
  if (task.completed) return false;

  final view = normalizeDate(viewDate);
  final created = normalizeDate(task.createdAt);
  return !view.isBefore(created);
}

FloatingTaskDeadlineUrgency floatingTaskDeadlineUrgency(
  FloatingTask task,
  DateTime viewDate,
) {
  if (task.deadline == null) return FloatingTaskDeadlineUrgency.none;

  final view = normalizeDate(viewDate);
  final deadline = normalizeDate(task.deadline!);

  if (deadline.isBefore(view)) return FloatingTaskDeadlineUrgency.overdue;
  if (deadline == view) return FloatingTaskDeadlineUrgency.dueToday;
  return FloatingTaskDeadlineUrgency.none;
}

List<FloatingTask> visibleFloatingTasksForDay(
  List<FloatingTask> tasks,
  DateTime viewDate,
) {
  final visible = tasks.where((task) => isFloatingTaskVisible(task, viewDate));
  final sorted = visible.toList()..sort(compareFloatingTasks);
  return sorted;
}

int compareFloatingTasks(FloatingTask a, FloatingTask b) {
  final aHasDeadline = a.deadline != null;
  final bHasDeadline = b.deadline != null;

  if (aHasDeadline && !bHasDeadline) return -1;
  if (!aHasDeadline && bHasDeadline) return 1;

  if (aHasDeadline && bHasDeadline) {
    final deadlineCompare = a.deadline!.compareTo(b.deadline!);
    if (deadlineCompare != 0) return deadlineCompare;
  }

  return a.createdAt.compareTo(b.createdAt);
}

String formatFloatingTaskDeadline(DateTime deadline) {
  final now = DateTime.now();
  final today = normalizeDate(now);
  final date = normalizeDate(deadline);
  final diff = date.difference(today).inDays;

  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Amanhã';
  if (diff == -1) return 'Ontem';

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month';
}
