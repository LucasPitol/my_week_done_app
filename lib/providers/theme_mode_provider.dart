import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference {
  light,
  dark,
  system,
}

const _themeModeKey = 'theme_mode';

class ThemeModeSettings extends AsyncNotifier<AppThemePreference> {
  @override
  Future<AppThemePreference> build() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModeKey);
    return AppThemePreference.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => AppThemePreference.system,
    );
  }

  Future<void> setPreference(AppThemePreference preference) async {
    state = AsyncData(preference);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, preference.name);
  }
}

final themeModeSettingsProvider =
    AsyncNotifierProvider<ThemeModeSettings, AppThemePreference>(
  ThemeModeSettings.new,
);

final resolvedThemeModeProvider = Provider<ThemeMode>((ref) {
  final preference =
      ref.watch(themeModeSettingsProvider).value ?? AppThemePreference.system;

  return switch (preference) {
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
    AppThemePreference.system => ThemeMode.system,
  };
});
