import 'package:flutter/material.dart';

enum BlockScopeChoice {
  allInGroup,
  singleOnly,
}

Future<BlockScopeChoice?> showBlockScopeDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String allLabel,
  required String singleLabel,
}) {
  return showDialog<BlockScopeChoice>(
    context: context,
    builder: (context) {
      var selected = BlockScopeChoice.allInGroup;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                const SizedBox(height: 16),
                RadioListTile<BlockScopeChoice>(
                  value: BlockScopeChoice.allInGroup,
                  groupValue: selected,
                  onChanged: (value) {
                    if (value != null) setState(() => selected = value);
                  },
                  title: Text(allLabel),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<BlockScopeChoice>(
                  value: BlockScopeChoice.singleOnly,
                  groupValue: selected,
                  onChanged: (value) {
                    if (value != null) setState(() => selected = value);
                  },
                  title: Text(singleLabel),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, selected),
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    },
  );
}
