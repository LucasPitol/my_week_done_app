import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/routine_block.dart';
import '../domain/block_form_utils.dart';
import '../providers/blocks_providers.dart';
import 'widgets/category_selector.dart';
import 'widgets/weekday_selector.dart';

class BlockFormScreen extends ConsumerStatefulWidget {
  const BlockFormScreen({
    super.key,
    this.block,
    this.duplicateFrom,
  });

  final RoutineBlock? block;
  final RoutineBlock? duplicateFrom;

  bool get isEditing => block != null;

  @override
  ConsumerState<BlockFormScreen> createState() => _BlockFormScreenState();
}

class _BlockFormScreenState extends ConsumerState<BlockFormScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Set<int> _selectedWeekdays;
  late TimeOfDay _selectedTime;
  String? _selectedCategory;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final source = widget.block ?? widget.duplicateFrom;

    _titleController.text = source?.title ?? '';
    _selectedTime = source != null
        ? timeOfDayFromDateTime(source.startTime)
        : const TimeOfDay(hour: 7, minute: 0);
    _selectedCategory = source?.category;

    if (widget.isEditing) {
      _selectedWeekdays = {widget.block!.weekday};
    } else if (widget.duplicateFrom != null) {
      _selectedWeekdays = {};
    } else {
      _selectedWeekdays = {};
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um dia')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final startTime = dateTimeFromTimeOfDay(_selectedTime);
    final actions = ref.read(blockActionsProvider);

    try {
      if (widget.isEditing) {
        await actions.updateBlock(
          widget.block!.copyWith(
            title: _titleController.text.trim(),
            weekday: _selectedWeekdays.first,
            startTime: startTime,
            category: _selectedCategory,
          ),
        );
      } else {
        await actions.createBlocks(
          title: _titleController.text.trim(),
          startTime: startTime,
          weekdays: _selectedWeekdays,
          category: _selectedCategory,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    if (!widget.isEditing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir rotina?'),
        content: Text(
          'A rotina "${widget.block!.title}" será removida.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await ref.read(blockActionsProvider).deleteBlock(widget.block!.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.isEditing;
    final isDuplicating = widget.duplicateFrom != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Editar rotina'
              : isDuplicating
                  ? 'Duplicar rotina'
                  : 'Nova rotina',
        ),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _isSaving ? null : _delete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nome da rotina',
                hintText: 'Ex: Treino, Trabalho, Ler',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe um nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Horário', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.schedule),
              label: Text(formatBlockTime(dateTimeFromTimeOfDay(_selectedTime))),
            ),
            const SizedBox(height: 24),
            Text(
              isEditing ? 'Dia da semana' : 'Dias da semana',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            if (!isEditing)
              Text(
                'Selecione vários dias para criar a mesma rotina de uma vez.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 8),
            WeekdaySelector(
              selectedWeekdays: _selectedWeekdays,
              singleSelection: isEditing,
              onChanged: (days) => setState(() => _selectedWeekdays = days),
            ),
            const SizedBox(height: 8),
            if (!isEditing)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    setState(() => _selectedWeekdays = {1, 2, 3, 4, 5});
                  },
                  child: const Text('Seg–Sex'),
                ),
              ),
            const SizedBox(height: 24),
            Text('Categoria (opcional)', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            CategorySelector(
              selectedCategory: _selectedCategory,
              onChanged: (category) =>
                  setState(() => _selectedCategory = category),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Salvar alterações' : 'Criar rotina'),
            ),
          ],
        ),
      ),
    );
  }
}
