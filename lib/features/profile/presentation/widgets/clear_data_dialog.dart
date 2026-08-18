import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/profile_constants.dart';
import '../../../../providers/repository_providers.dart';

Future<bool> showClearDataFlow(BuildContext context, WidgetRef ref) async {
  final firstConfirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Limpar dados?'),
      content: const Text(
        'Isso apaga todas as rotinas, conclusões e tarefas soltas. '
        'Não há backup em nuvem — a ação é irreversível.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Continuar'),
        ),
      ],
    ),
  );

  if (firstConfirmed != true || !context.mounted) return false;

  final typedConfirmation = await showDialog<bool>(
    context: context,
    builder: (context) => const _TypeToConfirmDialog(),
  );

  if (typedConfirmation != true) return false;

  await ref.read(routineRepositoryProvider).clearAllData();
  return true;
}

class _TypeToConfirmDialog extends StatefulWidget {
  const _TypeToConfirmDialog();

  @override
  State<_TypeToConfirmDialog> createState() => _TypeToConfirmDialogState();
}

class _TypeToConfirmDialogState extends State<_TypeToConfirmDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      _controller.text.trim() == ProfileConstants.clearDataConfirmationWord;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Confirme a exclusão'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Digite "${ProfileConstants.clearDataConfirmationWord}" para confirmar.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: ProfileConstants.clearDataConfirmationWord,
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: _canConfirm
                ? (_) => Navigator.pop(context, true)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: _canConfirm ? () => Navigator.pop(context, true) : null,
          child: const Text('Limpar dados'),
        ),
      ],
    );
  }
}
