import 'package:flutter/material.dart';

/// Paleta do app — ver [docs/styles.md].
abstract final class AppColors {
  // ── Dark (padrão) ──────────────────────────────────────────────────────────

  static const darkBackground = Color(0xFF0B0F0D);
  static const darkSurface = Color(0xFF151A17);
  static const darkSurfaceElevated = Color(0xFF1D2420);
  static const darkBorder = Color(0xFF2A322D);
  static const darkTextPrimary = Color(0xFFEDECE6);
  static const darkTextSecondary = Color(0xFF9AA39C);
  static const darkPrimary = Color(0xFF6FCF97);

  // ── Light (secundário) ─────────────────────────────────────────────────────

  static const lightBackground = Color(0xFFF5F2EA);
  static const lightSurface = Color(0xFFFBFAF6);
  static const lightSurfaceElevated = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE2DDD1);
  static const lightTextPrimary = Color(0xFF1C201D);
  static const lightTextSecondary = Color(0xFF6E7872);
  static const lightPrimary = Color(0xFF3F9463);

  // ── Acentos semânticos (ambos os temas) ──────────────────────────────────

  /// Conclusão, anel de aderência, dia ativo.
  static const primaryAccent = darkPrimary;

  /// Tarefas soltas com prazo vencido.
  static const urgency = Color(0xFFE8846E);

  /// Prazo próximo — estado intermediário.
  static const warning = Color(0xFFE8B86E);
}
