import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class EmptyBlocksState extends StatelessWidget {
  const EmptyBlocksState({
    super.key,
    required this.onCreate,
  });

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              TablerIcons.list_details,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma rotina criada',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Monte sua rotina semanal com horários fixos que se repetem toda semana.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(TablerIcons.plus),
              label: const Text('Criar primeira rotina'),
            ),
          ],
        ),
      ),
    );
  }
}
