import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkBackground,
          secondary: AppColors.darkSurfaceElevated,
          onSecondary: AppColors.darkTextPrimary,
          tertiary: AppColors.warning,
          onTertiary: AppColors.darkBackground,
          error: AppColors.urgency,
          onError: AppColors.darkTextPrimary,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          onSurfaceVariant: AppColors.darkTextSecondary,
          outline: AppColors.darkBorder,
          outlineVariant: AppColors.darkBorder,
          surfaceContainerLowest: AppColors.darkBackground,
          surfaceContainerLow: AppColors.darkSurface,
          surfaceContainer: AppColors.darkSurface,
          surfaceContainerHigh: AppColors.darkSurfaceElevated,
          surfaceContainerHighest: AppColors.darkSurfaceElevated,
        ),
        scaffoldBackground: AppColors.darkBackground,
      );

  static ThemeData light() => _build(
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.lightPrimary,
          onPrimary: AppColors.lightSurface,
          secondary: AppColors.lightSurfaceElevated,
          onSecondary: AppColors.lightTextPrimary,
          tertiary: AppColors.warning,
          onTertiary: AppColors.lightTextPrimary,
          error: AppColors.urgency,
          onError: AppColors.lightSurface,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightTextPrimary,
          onSurfaceVariant: AppColors.lightTextSecondary,
          outline: AppColors.lightBorder,
          outlineVariant: AppColors.lightBorder,
          surfaceContainerLowest: AppColors.lightBackground,
          surfaceContainerLow: AppColors.lightSurface,
          surfaceContainer: AppColors.lightSurface,
          surfaceContainerHigh: AppColors.lightSurfaceElevated,
          surfaceContainerHighest: AppColors.lightSurfaceElevated,
        ),
        scaffoldBackground: AppColors.lightBackground,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
  }) {
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      useMaterial3: true,
      textTheme: _textTheme(colorScheme),
      dividerColor: colorScheme.outline,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scaffoldBackground,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: _satoshi(
          ThemeData(brightness: brightness).textTheme.titleLarge,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: colorScheme.surfaceContainerHigh,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    final inter = GoogleFonts.interTextTheme();
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    return inter.copyWith(
      displayLarge:
          _satoshi(inter.displayLarge, fontWeight: FontWeight.w700, color: onSurface),
      displayMedium:
          _satoshi(inter.displayMedium, fontWeight: FontWeight.w700, color: onSurface),
      displaySmall:
          _satoshi(inter.displaySmall, fontWeight: FontWeight.w600, color: onSurface),
      headlineLarge:
          _satoshi(inter.headlineLarge, fontWeight: FontWeight.w700, color: onSurface),
      headlineMedium: _satoshi(
        inter.headlineMedium,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      headlineSmall: _satoshi(
        inter.headlineSmall,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleLarge:
          _satoshi(inter.titleLarge, fontWeight: FontWeight.w600, color: onSurface),
      titleMedium:
          _satoshi(inter.titleMedium, fontWeight: FontWeight.w500, color: onSurface),
      titleSmall:
          _satoshi(inter.titleSmall, fontWeight: FontWeight.w500, color: onSurface),
      bodyLarge: inter.bodyLarge?.copyWith(color: onSurface),
      bodyMedium: inter.bodyMedium?.copyWith(color: onSurface),
      bodySmall: inter.bodySmall?.copyWith(color: onSurfaceVariant),
      labelLarge: inter.labelLarge?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: inter.labelMedium?.copyWith(
        color: onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: inter.labelSmall?.copyWith(
        color: onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static TextStyle? _satoshi(
    TextStyle? base, {
    required FontWeight fontWeight,
    Color? color,
  }) {
    return base?.copyWith(
      fontFamily: AppFonts.satoshi,
      fontWeight: fontWeight,
      color: color ?? base.color,
    );
  }
}
