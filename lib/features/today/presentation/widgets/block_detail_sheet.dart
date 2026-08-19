import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_primary_button.dart';
import '../../../../domain/entities/routine_block.dart';
import '../../../../providers/repository_providers.dart';
import '../../../blocks/domain/block_form_utils.dart';
import '../../providers/today_providers.dart';

Future<void> showBlockDetailSheet({
  required BuildContext context,
  required WidgetRef ref,
  required RoutineBlock block,
  required DateTime date,
  required bool completed,
  String? note,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (sheetContext) {
      return BlockDetailSheet(
        block: block,
        date: date,
        initialCompleted: completed,
        initialNote: note,
      );
    },
  );
}

class BlockDetailSheet extends ConsumerStatefulWidget {
  const BlockDetailSheet({
    super.key,
    required this.block,
    required this.date,
    required this.initialCompleted,
    this.initialNote,
  });

  final RoutineBlock block;
  final DateTime date;
  final bool initialCompleted;
  final String? initialNote;

  @override
  ConsumerState<BlockDetailSheet> createState() => _BlockDetailSheetState();
}

class _BlockDetailSheetState extends ConsumerState<BlockDetailSheet> {
  late final TextEditingController _noteController;
  late bool _completed;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote ?? '');
    _completed = widget.initialCompleted;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _persistNote() async {
    final trimmed = _noteController.text.trim();
    final normalized = trimmed.isEmpty ? null : trimmed;
    final initial = widget.initialNote?.trim();
    final initialNormalized = (initial == null || initial.isEmpty) ? null : initial;

    if (normalized == initialNormalized) return;

    setState(() => _saving = true);
    try {
      await ref.read(routineRepositoryProvider).updateCompletionNote(
            routineBlockId: widget.block.id,
            date: widget.date,
            note: normalized,
          );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggleCompleted(bool value) async {
    if (_completed == value) return;

    setState(() => _completed = value);
    await toggleBlockCompletion(
      ref,
      routineBlockId: widget.block.id,
      date: widget.date,
      completed: value,
    );
  }

  Future<void> _close() async {
    await _persistNote();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _close();
      },
      child: Container(
        color: theme.colorScheme.surface,
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              widget.block.title,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              formatBlockTime(widget.block.startTime),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Concluído'),
              value: _completed,
              onChanged: _toggleCompleted,
            ),
            const SizedBox(height: 8),
            Text(
              'Nota',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Opcional — ex.: 3 séries, leitura cap. 2…',
                border: OutlineInputBorder(),
              ),
              onEditingComplete: _persistNote,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                onPressed: _saving ? null : _close,
                label: _saving ? 'Salvando…' : 'Fechar',
                isLoading: _saving,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
