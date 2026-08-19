import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/profile_constants.dart';
import '../../../../core/utils/clipboard_utils.dart';

Future<void> showPixQrSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (context) {
      final theme = Theme.of(context);

      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Pix',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Escaneie ou copie a chave para apoiar o projeto.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: QrImageView(
                  data: ProfileConstants.pixKey,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              ProfileConstants.pixKey,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => copyToClipboard(
                context,
                text: ProfileConstants.pixKey,
              ),
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copiar chave'),
            ),
          ],
        ),
      );
    },
  );
}
