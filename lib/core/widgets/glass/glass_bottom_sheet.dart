import 'package:flutter/material.dart';

import '../../theme/glass/glass_tokens.dart';
import 'glass_surface.dart';

/// Bottom sheet modal com fundo glass — conteúdo interno permanece opaco.
Future<T?> showGlassBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
}) {
  final theme = Theme.of(context);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: theme.colorScheme.scrim.withValues(alpha: 0.45),
    enableDrag: true,
    showDragHandle: false,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: GlassSurface(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(GlassTokens.bottomSheetTopRadius),
          ),
          blurSigma: GlassTokens.sheetBlur,
          backgroundOpacity: GlassTokens.sheetOpacity,
          child: Material(
            type: MaterialType.transparency,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(GlassTokens.bottomSheetTopRadius),
            ),
            child: builder(context),
          ),
        ),
      );
    },
  );
}
