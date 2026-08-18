import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../theme/glass/glass_layout_metrics.dart';
import '../../theme/glass/glass_tokens.dart';
import 'glass_surface.dart';

class GlassFab extends StatefulWidget {
  const GlassFab({
    super.key,
    required this.onPressed,
    this.tooltip = 'Novo',
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  State<GlassFab> createState() => _GlassFabState();
}

class _GlassFabState extends State<GlassFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      label: widget.tooltip,
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTapDown: reduceMotion ? null : _handleTapDown,
          onTapUp: reduceMotion ? null : _handleTapUp,
          onTapCancel: reduceMotion ? null : _handleTapCancel,
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _scale,
            builder: (context, child) {
              return Transform.scale(
                scale: reduceMotion ? 1 : _scale.value,
                child: child,
              );
            },
            child: SizedBox(
              width: GlassLayoutMetrics.fabSize,
              height: GlassLayoutMetrics.fabSize,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GlassSurface(
                    borderRadius: BorderRadius.circular(GlassLayoutMetrics.fabSize / 2),
                    blurSigma: GlassTokens.fabBlur,
                    backgroundOpacity: GlassTokens.fabOpacity,
                    child: const SizedBox.expand(),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.onSurface.withValues(alpha: 0.16),
                          theme.colorScheme.onSurface.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.45],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      TablerIcons.plus,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
