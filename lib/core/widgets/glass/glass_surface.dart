import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/glass_effects_provider.dart';
import '../../theme/glass/glass_tokens.dart';

/// Superfície translúcida com blur ou fallback sólido (acessibilidade).
class GlassSurface extends ConsumerWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.blurSigma = GlassTokens.tabBarBlur,
    this.backgroundOpacity = GlassTokens.tabBarOpacity,
    this.tintStrength = GlassTokens.tintStrength,
    this.showBorder = true,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;
  final double backgroundOpacity;
  final double tintStrength;
  final bool showBorder;

  static bool shouldUseSolidFallback(BuildContext context, bool reduceEffects) {
    return reduceEffects || MediaQuery.highContrastOf(context);
  }

  static Color glassFillColor(
    ColorScheme scheme, {
    required double backgroundOpacity,
    required double tintStrength,
    Brightness brightness = Brightness.dark,
  }) {
    final isLight = brightness == Brightness.light;
    final adjustedOpacity =
        isLight ? (backgroundOpacity + 0.1).clamp(0.0, 1.0) : backgroundOpacity;
    final adjustedTint = isLight ? tintStrength * 0.75 : tintStrength;

    final base =
        scheme.surfaceContainerHigh.withValues(alpha: adjustedOpacity);
    return Color.alphaBlend(
      scheme.primary.withValues(alpha: adjustedTint),
      base,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reduceEffects = ref.watch(reduceGlassEffectsProvider);
    final useSolid = shouldUseSolidFallback(context, reduceEffects);

    if (useSolid) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: borderRadius,
          border: showBorder
              ? Border.all(color: theme.colorScheme.outline, width: GlassTokens.borderWidth)
              : null,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
    }

    final fillColor = glassFillColor(
      theme.colorScheme,
      backgroundOpacity: backgroundOpacity,
      tintStrength: tintStrength,
      brightness: theme.brightness,
    );
    final borderColor = theme.colorScheme.onSurface.withValues(
      alpha: GlassTokens.borderOpacity,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius,
            border: showBorder
                ? Border.all(color: borderColor, width: GlassTokens.borderWidth)
                : null,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(
                  alpha: theme.brightness == Brightness.light ? 0.12 : 0.2,
                ),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
