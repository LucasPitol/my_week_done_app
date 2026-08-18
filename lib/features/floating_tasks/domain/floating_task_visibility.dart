import '../../../data/mappers/routine_mappers.dart';
import '../../../domain/entities/floating_task.dart';

enum FloatingTaskDeadlineUrgency { none, dueToday, overdue }

const completedTasksVisibleMonths = 2;

DateTime completedTasksVisibleSince(DateTime reference) {
  final today = normalizeDate(reference);
  var month = today.month - completedTasksVisibleMonths;
  var year = today.year;
  if (month <= 0) {
    month += 12;
    year -= 1;
  }
  final lastDayOfMonth = DateTime(year, month + 1, 0).day;
  final day = today.day > lastDayOfMonth ? lastDayOfMonth : today.day;
  return DateTime(year, month, day);
}

DateTime floatingTaskCompletedAt(FloatingTask task) =>
    normalizeDate(task.completedAt ?? task.createdAt);

bool isCompletedFloatingTaskWithinVisibleHistory(
  FloatingTask task,
  DateTime reference,
) {
  if (!task.completed) return false;
  return !floatingTaskCompletedAt(task)
      .isBefore(completedTasksVisibleSince(reference));
}

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

/// Tarefas soltas com prazo na data indicada (visão calendário).
List<FloatingTask> floatingTasksDueOnDate(
  List<FloatingTask> tasks,
  DateTime date,
) {
  final normalized = normalizeDate(date);
  final due = tasks.where((task) {
    if (task.completed || task.deadline == null) return false;
    return normalizeDate(task.deadline!) == normalized;
  }).toList()
    ..sort(compareFloatingTasks);
  return due;
}

bool hasFloatingTasksDueInRange(
  List<FloatingTask> tasks,
  DateTime start,
  DateTime end,
) {
  final normalizedStart = normalizeDate(start);
  final normalizedEnd = normalizeDate(end);
  return tasks.any((task) {
    if (task.completed || task.deadline == null) return false;
    final deadline = normalizeDate(task.deadline!);
    return !deadline.isBefore(normalizedStart) &&
        !deadline.isAfter(normalizedEnd);
  });
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
