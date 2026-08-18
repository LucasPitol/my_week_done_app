import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/platform/accessibility_platform.dart';
import 'app_lifecycle_provider.dart';

const _reduceGlassEffectsKey = 'reduce_glass_effects';

class GlassEffectsSettings extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reduceGlassEffectsKey) ?? false;
  }

  Future<void> setReduceEffects(bool enabled) async {
    state = AsyncData(enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reduceGlassEffectsKey, enabled);
  }
}

final glassEffectsSettingsProvider =
    AsyncNotifierProvider<GlassEffectsSettings, bool>(GlassEffectsSettings.new);

final systemReduceTransparencyProvider = FutureProvider<bool>((ref) async {
  ref.watch(appLifecycleRefreshProvider);
  return AccessibilityPlatform.isReduceTransparencyEnabled();
});

/// Preferência manual OU redução de transparência do sistema (iOS).
final reduceGlassEffectsProvider = Provider<bool>((ref) {
  final manual = ref.watch(glassEffectsSettingsProvider).value ?? false;
  final system = ref.watch(systemReduceTransparencyProvider).value ?? false;
  return manual || system;
});
