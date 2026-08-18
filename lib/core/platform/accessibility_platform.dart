import 'package:flutter/services.dart';

/// Preferências de acessibilidade expostas pela plataforma nativa.
abstract final class AccessibilityPlatform {
  static const _channel = MethodChannel('my_week_done_app/accessibility');

  static Future<bool> isReduceTransparencyEnabled() async {
    try {
      final enabled =
          await _channel.invokeMethod<bool>('isReduceTransparencyEnabled');
      return enabled ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
