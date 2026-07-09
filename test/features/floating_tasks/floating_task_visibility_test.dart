import 'package:flutter_test/flutter_test.dart';

import 'package:my_week_done_app/domain/entities/floating_task.dart';
import 'package:my_week_done_app/features/floating_tasks/domain/floating_task_visibility.dart';

void main() {
  final tuesday = DateTime(2026, 7, 7);
  final thursday = DateTime(2026, 7, 9);
  final friday = DateTime(2026, 7, 10);

  FloatingTask task({
    String id = 'task-1',
    String title = 'Comprar presente',
    DateTime? deadline,
    bool completed = false,
    DateTime? createdAt,
  }) {
    return FloatingTask(
      id: id,
      title: title,
      deadline: deadline,
      completed: completed,
      createdAt: createdAt ?? tuesday,
    );
  }

  group('isFloatingTaskVisible', () {
    test('tarefa sem prazo aparece a partir da criação', () {
      final item = task(createdAt: tuesday);

      expect(isFloatingTaskVisible(item, tuesday), isTrue);
      expect(isFloatingTaskVisible(item, thursday), isTrue);
      expect(isFloatingTaskVisible(item, tuesday.subtract(const Duration(days: 1))),
          isFalse);
    });

    test('tarefa concluída não aparece', () {
      expect(
        isFloatingTaskVisible(task(completed: true), thursday),
        isFalse,
      );
    });

    test('tarefa com prazo futuro aparece antes do prazo', () {
      final item = task(deadline: friday, createdAt: tuesday);

      expect(isFloatingTaskVisible(item, thursday), isTrue);
    });
  });

  group('floatingTaskDeadlineUrgency', () {
    test('prazo hoje gera urgência de aviso', () {
      expect(
        floatingTaskDeadlineUrgency(task(deadline: thursday), thursday),
        FloatingTaskDeadlineUrgency.dueToday,
      );
    });

    test('prazo vencido gera urgência máxima', () {
      expect(
        floatingTaskDeadlineUrgency(task(deadline: tuesday), thursday),
        FloatingTaskDeadlineUrgency.overdue,
      );
    });

    test('sem prazo não gera urgência', () {
      expect(
        floatingTaskDeadlineUrgency(task(), thursday),
        FloatingTaskDeadlineUrgency.none,
      );
    });
  });

  group('compareFloatingTasks', () {
    test('ordena por prazo mais próximo primeiro', () {
      final sorted = [
        task(id: 'a', deadline: friday),
        task(id: 'b', deadline: thursday),
        task(id: 'c'),
      ]..sort(compareFloatingTasks);

      expect(sorted.map((t) => t.id).toList(), ['b', 'a', 'c']);
    });

    test('sem prazo fica por último', () {
      final sorted = [
        task(id: 'no-deadline'),
        task(id: 'soon', deadline: thursday),
      ]..sort(compareFloatingTasks);

      expect(sorted.first.id, 'soon');
      expect(sorted.last.id, 'no-deadline');
    });
  });

  group('visibleFloatingTasksForDay', () {
    test('filtra concluídas e ordena', () {
      final tasks = [
        task(id: 'done', completed: true),
        task(id: 'later', deadline: friday),
        task(id: 'soon', deadline: thursday),
      ];

      final visible = visibleFloatingTasksForDay(tasks, thursday);

      expect(visible.map((t) => t.id).toList(), ['soon', 'later']);
    });
  });
}
