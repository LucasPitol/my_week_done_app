import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/day_index.dart';
import '../domain/today_view_mode.dart';

const _viewModeKey = 'today_view_mode';

final selectedDayProvider = StateProvider<DateTime>((ref) {
  return normalizeDay(DateTime.now());
});

final todayViewModeProvider =
    StateNotifierProvider<TodayViewModeNotifier, TodayViewMode>((ref) {
  return TodayViewModeNotifier();
});

class TodayViewModeNotifier extends StateNotifier<TodayViewMode> {
  TodayViewModeNotifier() : super(TodayViewMode.day) {
    _load();
  }

  TodayViewModeNotifier.withInitial(super.mode);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_viewModeKey);
    if (saved == TodayViewMode.calendar.storageKey) {
      state = TodayViewMode.calendar;
    }
  }

  Future<void> setMode(TodayViewMode mode) async {
    if (state == mode) return;
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_viewModeKey, mode.storageKey);
  }
}
