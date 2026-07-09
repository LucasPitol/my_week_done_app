import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_fonts.dart';

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D5B),
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: _textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        titleTextStyle: _satoshi(
          ThemeData.light().textTheme.titleLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    final inter = GoogleFonts.interTextTheme();
    final onSurface = colorScheme.onSurface;

    return inter.copyWith(
      displayLarge: _satoshi(inter.displayLarge, fontWeight: FontWeight.w700),
      displayMedium: _satoshi(inter.displayMedium, fontWeight: FontWeight.w700),
      displaySmall: _satoshi(inter.displaySmall, fontWeight: FontWeight.w600),
      headlineLarge: _satoshi(inter.headlineLarge, fontWeight: FontWeight.w700),
      headlineMedium:
          _satoshi(inter.headlineMedium, fontWeight: FontWeight.w600),
      headlineSmall: _satoshi(inter.headlineSmall, fontWeight: FontWeight.w600),
      titleLarge: _satoshi(inter.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: _satoshi(inter.titleMedium, fontWeight: FontWeight.w500),
      titleSmall: _satoshi(inter.titleSmall, fontWeight: FontWeight.w500),
      bodyLarge: inter.bodyLarge?.copyWith(color: onSurface),
      bodyMedium: inter.bodyMedium?.copyWith(color: onSurface),
      bodySmall: inter.bodySmall?.copyWith(color: onSurface),
      labelLarge: inter.labelLarge?.copyWith(color: onSurface),
      labelMedium: inter.labelMedium?.copyWith(color: onSurface),
      labelSmall: inter.labelSmall?.copyWith(color: onSurface),
    );
  }

  static TextStyle? _satoshi(
    TextStyle? base, {
    required FontWeight fontWeight,
  }) {
    return base?.copyWith(
      fontFamily: AppFonts.satoshi,
      fontWeight: fontWeight,
    );
  }
}
