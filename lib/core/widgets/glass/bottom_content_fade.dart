import 'package:flutter/material.dart';

import '../../theme/glass/glass_layout_metrics.dart';

/// Gradiente sutil na borda inferior do conteúdo, acima da tab bar.
class BottomContentFade extends StatelessWidget {
  const BottomContentFade({super.key});

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;

    return IgnorePointer(
      child: SizedBox(
        height: GlassLayoutMetrics.bottomFadeHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                background.withValues(alpha: 0),
                background.withValues(alpha: 0.55),
                background.withValues(alpha: 0.92),
              ],
              stops: const [0, 0.55, 1],
            ),
          ),
        ),
      ),
    );
  }
}
