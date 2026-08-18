import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/floating_task.dart';
import '../../../providers/repository_providers.dart';
import '../domain/floating_task_visibility.dart';

final floatingTasksProvider = StreamProvider<List<FloatingTask>>((ref) {
  return ref.watch(routineRepositoryProvider).watchFloatingTasks();
});

final visibleFloatingTasksProvider =
    Provider.family<List<FloatingTask>, DateTime>((ref, date) {
  final tasks = ref.watch(floatingTasksProvider).valueOrNull ?? [];
  return visibleFloatingTasksForDay(tasks, date);
});

final floatingTaskActionsProvider = Provider<FloatingTaskActions>((ref) {
  return FloatingTaskActions(ref);
});

class FloatingTaskActions {
  FloatingTaskActions(this._ref);

  final Ref _ref;
  final _uuid = const Uuid();

  Future<void> createTask({
    required String title,
    String? category,
    DateTime? deadline,
  }) async {
    final repository = _ref.read(routineRepositoryProvider);
    await repository.saveFloatingTask(
      FloatingTask(
        id: _uuid.v4(),
        title: title.trim(),
        category: category,
        deadline: deadline,
        completed: false,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateTask({
    required FloatingTask task,
    required String title,
    String? category,
    DateTime? deadline,
    bool clearDeadline = false,
  }) async {
    final repository = _ref.read(routineRepositoryProvider);
    await repository.saveFloatingTask(
      task.copyWith(
        title: title.trim(),
        category: category,
        deadline: deadline,
        clearDeadline: clearDeadline,
      ),
    );
  }

  Future<void> deleteTask(String id) async {
    await _ref.read(routineRepositoryProvider).deleteFloatingTask(id);
  }

  Future<void> toggleCompletion({
    required String id,
    required bool completed,
  }) async {
    await _ref.read(routineRepositoryProvider).toggleFloatingTaskCompletion(
          id: id,
          completed: completed,
        );
  }
}

Future<void> toggleFloatingTaskCompletion(
  WidgetRef ref, {
  required String id,
  required bool completed,
}) {
  return ref.read(floatingTaskActionsProvider).toggleCompletion(
        id: id,
        completed: completed,
      );
}

List<FloatingTask> pendingFloatingTasks(List<FloatingTask> tasks) {
  final pending = tasks.where((task) => !task.completed).toList()
    ..sort(compareFloatingTasks);
  return pending;
}

List<FloatingTask> completedFloatingTasks(
  List<FloatingTask> tasks, {
  DateTime? reference,
  bool limitToRecentHistory = false,
}) {
  final ref = reference ?? DateTime.now();
  final completed = tasks
      .where((task) {
        if (!task.completed) return false;
        if (limitToRecentHistory) {
          return isCompletedFloatingTaskWithinVisibleHistory(task, ref);
        }
        return true;
      })
      .toList()
    ..sort((a, b) {
      return floatingTaskCompletedAt(b).compareTo(floatingTaskCompletedAt(a));
    });
  return completed;
}
