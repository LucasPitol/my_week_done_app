import 'package:flutter_test/flutter_test.dart';

import 'package:my_week_done_app/domain/entities/floating_task.dart';
import 'package:my_week_done_app/features/floating_tasks/domain/floating_task_visibility.dart';
import 'package:my_week_done_app/features/floating_tasks/providers/floating_task_providers.dart';

void main() {
  final reference = DateTime(2026, 8, 3);

  FloatingTask completedTask({
    required String id,
    required DateTime completedAt,
  }) {
    return FloatingTask(
      id: id,
      title: 'Tarefa $id',
      completed: true,
      completedAt: completedAt,
      createdAt: completedAt.subtract(const Duration(days: 1)),
    );
  }

  group('completedTasksVisibleSince', () {
    test('subtrai 2 meses respeitando o último dia do mês', () {
      expect(
        completedTasksVisibleSince(DateTime(2026, 3, 31)),
        DateTime(2026, 1, 31),
      );
    });

    test('ajusta dia quando o mês de destino é mais curto', () {
      expect(
        completedTasksVisibleSince(DateTime(2026, 3, 30)),
        DateTime(2026, 1, 30),
      );
    });
  });

  group('completedFloatingTasks', () {
    test('limita concluídas aos últimos 2 meses', () {
      final tasks = [
        completedTask(id: 'recent', completedAt: DateTime(2026, 7, 10)),
        completedTask(id: 'old', completedAt: DateTime(2026, 5, 1)),
        FloatingTask(
          id: 'pending',
          title: 'Pendente',
          completed: false,
          createdAt: DateTime(2026, 7, 1),
        ),
      ];

      final recent = completedFloatingTasks(
        tasks,
        reference: reference,
        limitToRecentHistory: true,
      );

      expect(recent.map((task) => task.id).toList(), ['recent']);
    });

    test('sem limite retorna todas as concluídas', () {
      final tasks = [
        completedTask(id: 'recent', completedAt: DateTime(2026, 7, 10)),
        completedTask(id: 'old', completedAt: DateTime(2026, 5, 1)),
      ];

      final completed = completedFloatingTasks(
        tasks,
        reference: reference,
      );

      expect(completed.map((task) => task.id).toList(), ['recent', 'old']);
    });

    test('usa createdAt quando completedAt é nulo', () {
      final tasks = [
        FloatingTask(
          id: 'legacy',
          title: 'Legado',
          completed: true,
          createdAt: DateTime(2026, 7, 1),
        ),
      ];

      final recent = completedFloatingTasks(
        tasks,
        reference: reference,
        limitToRecentHistory: true,
      );

      expect(recent.map((task) => task.id).toList(), ['legacy']);
    });
  });
}
