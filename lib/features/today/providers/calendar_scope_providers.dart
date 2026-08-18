import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/calendar_utils.dart';
import '../../../domain/entities/daily_completion.dart';
import '../../../providers/repository_providers.dart';
import '../domain/calendar_scope.dart';
import 'today_view_providers.dart';

const _calendarScopeKey = 'calendar_scope';

final currentMonthStartProvider = Provider<DateTime>((ref) {
  final selectedDay = ref.watch(selectedDayProvider);
  return startOfMonth(selectedDay);
});

final monthGridRangeProvider = Provider<(DateTime, DateTime)>((ref) {
  final monthStart = ref.watch(currentMonthStartProvider);
  final gridDays = daysForMonthGrid(monthStart);
  return (gridDays.first, gridDays.last);
});

final monthCompletionsProvider = StreamProvider<List<DailyCompletion>>((ref) {
  final (start, end) = ref.watch(monthGridRangeProvider);
  return ref
      .watch(routineRepositoryProvider)
      .watchCompletionsForRange(start, end);
});

final calendarScopeProvider =
    StateNotifierProvider<CalendarScopeNotifier, CalendarScope>((ref) {
  return CalendarScopeNotifier();
});

class CalendarScopeNotifier extends StateNotifier<CalendarScope> {
  CalendarScopeNotifier() : super(CalendarScope.week) {
    _load();
  }

  CalendarScopeNotifier.withInitial(super.scope);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_calendarScopeKey);
    if (saved == CalendarScope.month.storageKey) {
      state = CalendarScope.month;
    }
  }

  Future<void> setScope(CalendarScope scope) async {
    if (state == scope) return;
    state = scope;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calendarScopeKey, scope.storageKey);
  }
}
