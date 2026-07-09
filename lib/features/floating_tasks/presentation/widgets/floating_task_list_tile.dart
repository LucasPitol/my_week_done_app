import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../core/theme/category_colors.dart';
import '../../../../domain/entities/floating_task.dart';
import '../../../blocks/domain/block_form_utils.dart';
import '../../domain/floating_task_visibility.dart';

class FloatingTaskListTile extends StatelessWidget {
  const FloatingTaskListTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  });

  final FloatingTask task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = categoryColor(task.category, theme.colorScheme);
    final categoryLabel = BlockCategories.labelFor(task.category);
    final deadlineLabel = task.deadline != null
        ? formatFloatingTaskDeadline(task.deadline!)
        : 'Sem prazo';

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(
          task.completed ? TablerIcons.check : TablerIcons.checklist,
          size: 16,
          color: color,
        ),
      ),
      title: Text(
        task.title,
        style: theme.textTheme.titleSmall?.copyWith(
          decoration: task.completed ? TextDecoration.lineThrough : null,
          color: task.completed
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        [
          deadlineLabel,
          ?categoryLabel,
          if (task.completed) 'Concluída',
        ].whereType<String>().join(' · '),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: PopupMenuButton<_FloatingTaskAction>(
        onSelected: (action) {
          switch (action) {
            case _FloatingTaskAction.edit:
              onTap();
            case _FloatingTaskAction.delete:
              onDelete();
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: _FloatingTaskAction.edit,
            child: Text('Editar'),
          ),
          PopupMenuItem(
            value: _FloatingTaskAction.delete,
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

enum _FloatingTaskAction { edit, delete }
