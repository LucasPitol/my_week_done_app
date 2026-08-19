import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_fonts.dart';

/// Dimensões e efeitos do CTA primário — ver [docs/styles.md].
abstract final class AppPrimaryButtonMetrics {
  static const height = 52.0;
  static const horizontalPadding = 24.0;
  static const borderRadius = height / 2;
  static const shadowBlur = 20.0;
  static const shadowOffsetY = 6.0;
  static const shadowOpacity = 0.25;
  static const specularTopOpacity = 0.15;
  static const specularHeightFraction = 0.30;
  static const pressedScale = 0.97;
  static const pressedDarkenAmount = 0.10;
  static const disabledOpacity = 0.40;
}

class AppPrimaryButton extends StatefulWidget {
  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!_pressed && value) HapticFeedback.lightImpact();
    if (_pressed != value) setState(() => _pressed = value);
  }

  Color _backgroundColor(ColorScheme scheme, bool enabled) {
    if (!enabled) return scheme.outline;
    final base = scheme.primary;
    if (_pressed) {
      return Color.lerp(base, Colors.black, AppPrimaryButtonMetrics.pressedDarkenAmount)!;
    }
    return base;
  }

  Color _foregroundColor(ColorScheme scheme, bool enabled) {
    if (!enabled) return scheme.onSurfaceVariant;
    return scheme.onPrimary;
  }

  List<BoxShadow> _shadows(ColorScheme scheme, bool enabled) {
    if (!enabled || _pressed) return const [];
    return [
      BoxShadow(
        color: scheme.primary.withValues(alpha: AppPrimaryButtonMetrics.shadowOpacity),
        blurRadius: AppPrimaryButtonMetrics.shadowBlur,
        offset: const Offset(0, AppPrimaryButtonMetrics.shadowOffsetY),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = widget._isEnabled;

    final backgroundColor = _backgroundColor(scheme, enabled);
    final foregroundColor = _foregroundColor(scheme, enabled);
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      fontFamily: AppFonts.satoshi,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
      letterSpacing: 0.1,
    );

    final button = AnimatedScale(
      scale: enabled && _pressed ? AppPrimaryButtonMetrics.pressedScale : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        height: AppPrimaryButtonMetrics.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppPrimaryButtonMetrics.borderRadius),
          boxShadow: _shadows(scheme, enabled),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppPrimaryButtonMetrics.borderRadius),
          child: Material(
            color: backgroundColor,
            child: InkWell(
              onTap: enabled ? widget.onPressed : null,
              onTapDown: enabled ? (_) => _setPressed(true) : null,
              onTapUp: enabled ? (_) => _setPressed(false) : null,
              onTapCancel: enabled ? () => _setPressed(false) : null,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (enabled && !_pressed)
                    Align(
                      alignment: Alignment.topCenter,
                      child: FractionallySizedBox(
                        heightFactor: AppPrimaryButtonMetrics.specularHeightFraction,
                        widthFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(
                                  alpha: AppPrimaryButtonMetrics.specularTopOpacity,
                                ),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPrimaryButtonMetrics.horizontalPadding,
                      ),
                      child: widget.isLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: foregroundColor,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(widget.icon, size: 20, color: foregroundColor),
                                  const SizedBox(width: 8),
                                ],
                                Text(widget.label, style: labelStyle),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (!enabled) {
      return Opacity(
        opacity: AppPrimaryButtonMetrics.disabledOpacity,
        child: button,
      );
    }

    return button;
  }
}

/// Footer fixo com glass sutil para CTAs sobre conteúdo rolável.
class AppPrimaryButtonBar extends StatelessWidget {
  const AppPrimaryButtonBar({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _horizontalInset = 16.0;
  static const _topPadding = 12.0;
  static const _bottomExtra = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.72),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.35),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              _horizontalInset,
              _topPadding,
              _horizontalInset,
              bottomSafe + _bottomExtra,
            ),
            child: SizedBox(width: double.infinity, child: child),
          ),
        ),
      ),
    );
  }
}
