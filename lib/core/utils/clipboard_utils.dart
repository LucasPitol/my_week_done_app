import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> copyToClipboard(
  BuildContext context, {
  required String text,
  String message = 'Copiado',
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  HapticFeedback.lightImpact();

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
