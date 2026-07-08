import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/entities/daily_completion.dart';
import '../../domain/entities/routine_block.dart';
import '../../domain/repositories/routine_repository.dart';

/// Implementação local v1 (em memória).
/// Substituir por Drift/SQLite sem alterar a UI.
class LocalRoutineRepository implements RoutineRepository {
  LocalRoutineRepository({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  final List<RoutineBlock> _blocks = [];
  final List<DailyCompletion> _completions = [];

  final _blocksController = StreamController<List<RoutineBlock>>.broadcast();
  final _completionsControllers =
      <String, StreamController<List<DailyCompletion>>>{};

  void _emitBlocks() => _blocksController.add(List.unmodifiable(_blocks));

  void _emitCompletions(DateTime date) {
    final key = _dateKey(date);
    _completionsControllers[key]?.add(_completionsForDate(date));
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  List<DailyCompletion> _completionsForDate(DateTime date) {
    return _completions
        .where(
          (c) =>
              c.date.year == date.year &&
              c.date.month == date.month &&
              c.date.day == date.day,
        )
        .toList(growable: false);
  }

  @override
  Stream<List<RoutineBlock>> watchRoutineBlocks() {
    _emitBlocks();
    return _blocksController.stream;
  }

  @override
  Stream<List<DailyCompletion>> watchCompletionsForDate(DateTime date) {
    final key = _dateKey(date);
    final controller = _completionsControllers.putIfAbsent(
      key,
      () => StreamController<List<DailyCompletion>>.broadcast(),
    );
    controller.add(_completionsForDate(date));
    return controller.stream;
  }

  @override
  Future<void> saveRoutineBlock(RoutineBlock block) async {
    final index = _blocks.indexWhere((b) => b.id == block.id);
    if (index >= 0) {
      _blocks[index] = block;
    } else {
      _blocks.add(block);
    }
    _emitBlocks();
  }

  @override
  Future<void> deleteRoutineBlock(String id) async {
    _blocks.removeWhere((b) => b.id == id);
    _completions.removeWhere((c) => c.routineBlockId == id);
    _emitBlocks();
    for (final key in _completionsControllers.keys.toList()) {
      final parts = key.split('-').map(int.parse).toList();
      _emitCompletions(DateTime(parts[0], parts[1], parts[2]));
    }
  }

  @override
  Future<void> toggleCompletion({
    required String routineBlockId,
    required DateTime date,
    required bool completed,
  }) async {
    final normalized = DateTime(date.year, date.month, date.day);
    final index = _completions.indexWhere(
      (c) =>
          c.routineBlockId == routineBlockId &&
          c.date.year == normalized.year &&
          c.date.month == normalized.month &&
          c.date.day == normalized.day,
    );

    if (index >= 0) {
      _completions[index] =
          _completions[index].copyWith(completed: completed);
    } else {
      _completions.add(
        DailyCompletion(
          id: _uuid.v4(),
          routineBlockId: routineBlockId,
          date: normalized,
          completed: completed,
        ),
      );
    }
    _emitCompletions(normalized);
  }

  @override
  Future<void> updateCompletionNote({
    required String routineBlockId,
    required DateTime date,
    required String? note,
  }) async {
    final normalized = DateTime(date.year, date.month, date.day);
    final index = _completions.indexWhere(
      (c) =>
          c.routineBlockId == routineBlockId &&
          c.date.year == normalized.year &&
          c.date.month == normalized.month &&
          c.date.day == normalized.day,
    );

    if (index >= 0) {
      _completions[index] = _completions[index].copyWith(note: note);
    } else {
      _completions.add(
        DailyCompletion(
          id: _uuid.v4(),
          routineBlockId: routineBlockId,
          date: normalized,
          completed: false,
          note: note,
        ),
      );
    }
    _emitCompletions(normalized);
  }

  @override
  Future<double> adherenceForWeek(DateTime weekStart) async {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    var total = 0;
    var done = 0;

    for (var day = 0; day < 7; day++) {
      final date = start.add(Duration(days: day));
      final weekday = date.weekday;
      final blocksForDay =
          _blocks.where((b) => b.weekday == weekday).toList();
      total += blocksForDay.length;

      for (final block in blocksForDay) {
        final completion = _completions.where(
          (c) =>
              c.routineBlockId == block.id &&
              c.date.year == date.year &&
              c.date.month == date.month &&
              c.date.day == date.day &&
              c.completed,
        );
        if (completion.isNotEmpty) done++;
      }
    }

    if (total == 0) return 0;
    return done / total;
  }
}
