import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../core/theme/category_colors.dart';
import '../../../../domain/entities/routine_block.dart';
import '../../domain/block_form_utils.dart';

class BlockListTile extends StatelessWidget {
  const BlockListTile({
    super.key,
    required this.block,
    required this.onTap,
    required this.onDuplicate,
    required this.onDelete,
  });

  final RoutineBlock block;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = categoryColor(block.category, theme.colorScheme);
    final categoryLabel = BlockCategories.labelFor(block.category);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(TablerIcons.clock, size: 16, color: color),
      ),
      title: Text(block.title, style: theme.textTheme.titleSmall),
      subtitle: Text(
        [
          formatBlockTime(block.startTime),
          ?categoryLabel,
        ].whereType<String>().join(' · '),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: PopupMenuButton<_BlockAction>(
        onSelected: (action) {
          switch (action) {
            case _BlockAction.edit:
              onTap();
            case _BlockAction.duplicate:
              onDuplicate();
            case _BlockAction.delete:
              onDelete();
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: _BlockAction.edit,
            child: Text('Editar'),
          ),
          PopupMenuItem(
            value: _BlockAction.duplicate,
            child: Text('Duplicar'),
          ),
          PopupMenuItem(
            value: _BlockAction.delete,
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

enum _BlockAction { edit, duplicate, delete }
