import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/week_utils.dart';
import '../../../data/mappers/routine_mappers.dart';
import '../../../domain/entities/floating_task.dart';
import '../../../domain/entities/routine_block.dart';
import '../../floating_tasks/providers/floating_task_providers.dart';
import '../../today/providers/today_providers.dart';
import '../domain/block_form_utils.dart';
import '../domain/block_group_utils.dart';
import '../providers/blocks_providers.dart';
import 'widgets/block_scope_dialog.dart';
import 'widgets/category_selector.dart';
import 'widgets/weekday_selector.dart';

enum ItemFormMode { routine, floatingTask }

class BlockFormScreen extends ConsumerStatefulWidget {
  const BlockFormScreen({
    super.key,
    this.block,
    this.duplicateFrom,
    this.floatingTask,
    this.initialMode = ItemFormMode.routine,
  });

  final RoutineBlock? block;
  final RoutineBlock? duplicateFrom;
  final FloatingTask? floatingTask;
  final ItemFormMode initialMode;

  bool get isEditingRoutine => block != null;
  bool get isEditingFloatingTask => floatingTask != null;
  bool get isEditing => isEditingRoutine || isEditingFloatingTask;

  @override
  ConsumerState<BlockFormScreen> createState() => _BlockFormScreenState();
}

class _BlockFormScreenState extends ConsumerState<BlockFormScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late ItemFormMode _mode;
  late Set<int> _selectedWeekdays;
  late TimeOfDay _selectedTime;
  String? _selectedCategory;
  DateTime? _selectedDeadline;
  bool _hasDeadline = false;
  bool _isSaving = false;
  bool _initialWeekdaysLoaded = false;
  List<RoutineBlock> _groupMembers = [];

  bool get _isRoutineMode => _mode == ItemFormMode.routine;

  @override
  void initState() {
    super.initState();

    if (widget.isEditingFloatingTask) {
      _mode = ItemFormMode.floatingTask;
      final task = widget.floatingTask!;
      _titleController.text = task.title;
      _selectedCategory = task.category;
      _selectedDeadline = task.deadline;
      _hasDeadline = task.deadline != null;
      _selectedWeekdays = {};
      _selectedTime = const TimeOfDay(hour: 7, minute: 0);
    } else {
      _mode = widget.initialMode;
      final source = widget.block ?? widget.duplicateFrom;

      _titleController.text = source?.title ?? '';
      _selectedTime = source != null
          ? timeOfDayFromDateTime(source.startTime)
          : const TimeOfDay(hour: 7, minute: 0);
      _selectedCategory = source?.category;

      if (widget.isEditingRoutine) {
        _selectedWeekdays = {widget.block!.weekday};
      } else if (widget.duplicateFrom != null) {
        _selectedWeekdays = {widget.duplicateFrom!.weekday};
      } else {
        _selectedWeekdays = {};
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEditingRoutine && !_initialWeekdaysLoaded) {
      final allBlocks = ref.read(routineBlocksProvider).valueOrNull ?? [];
      _groupMembers = blocksInGroup(allBlocks, widget.block!);
      _selectedWeekdays = weekdaysInGroup(_groupMembers);
      _initialWeekdaysLoaded = true;
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

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = normalizeDate(picked);
        _hasDeadline = true;
      });
    }
  }

  Future<BlockScopeChoice?> _resolveScopeChoice({
    required bool isDelete,
  }) async {
    if (_groupMembers.length <= 1) {
      return isDelete ? BlockScopeChoice.singleOnly : BlockScopeChoice.allInGroup;
    }

    final otherDays = formatOtherWeekdaysLabel(
      weekdaysInGroup(_groupMembers),
      excludeWeekday: widget.block!.weekday,
    );

    return showBlockScopeDialog(
      context,
      title: isDelete ? 'Excluir rotina?' : 'Salvar alterações',
      message: isDelete
          ? 'Esta rotina também existe em $otherDays.'
          : 'Esta rotina também existe em $otherDays. Como deseja aplicar?',
      allLabel: isDelete
          ? 'Excluir todas as ocorrências'
          : 'Aplicar a todas as ocorrências',
      singleLabel: isDelete
          ? 'Excluir apenas ${weekdayFullLabels[widget.block!.weekday]}'
          : 'Alterar apenas ${weekdayFullLabels[widget.block!.weekday]}',
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isRoutineMode) {
      await _saveRoutine();
    } else {
      await _saveFloatingTask();
    }
  }

  Future<void> _saveFloatingTask() async {
    final title = _titleController.text.trim();
    final deadline = _hasDeadline ? _selectedDeadline : null;
    final actions = ref.read(floatingTaskActionsProvider);

    setState(() => _isSaving = true);

    try {
      if (widget.isEditingFloatingTask) {
        await actions.updateTask(
          task: widget.floatingTask!,
          title: title,
          category: _selectedCategory,
          deadline: deadline,
          clearDeadline: !_hasDeadline,
        );
      } else {
        await actions.createTask(
          title: title,
          category: _selectedCategory,
          deadline: deadline,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveRoutine() async {
    if (_selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um dia')),
      );
      return;
    }

    final startTime = dateTimeFromTimeOfDay(_selectedTime);
    final title = _titleController.text.trim();
    final actions = ref.read(blockActionsProvider);

    var applyToAll = true;
    if (widget.isEditingRoutine) {
      final hasChanges = hasGroupChanges(
        block: widget.block!,
        groupBlocks: _groupMembers,
        title: title,
        startTime: startTime,
        weekdays: _selectedWeekdays,
        category: _selectedCategory,
      );

      if (!hasChanges) {
        if (!mounted) return;
        Navigator.of(context).pop();
        return;
      }

      if (_groupMembers.length > 1) {
        final scope = await _resolveScopeChoice(isDelete: false);
        if (!mounted || scope == null) return;
        applyToAll = scope == BlockScopeChoice.allInGroup;
      }
    }

    setState(() => _isSaving = true);

    try {
      if (widget.isEditingRoutine) {
        await actions.updateBlock(
          block: widget.block!,
          groupMembers: _groupMembers,
          title: title,
          startTime: startTime,
          weekdays: _selectedWeekdays,
          category: _selectedCategory,
          applyToAll: applyToAll,
        );
      } else {
        await actions.createBlocks(
          title: title,
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

    if (widget.isEditingFloatingTask) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Excluir tarefa?'),
          content: Text(
            'A tarefa "${widget.floatingTask!.title}" será removida.',
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

      await ref
          .read(floatingTaskActionsProvider)
          .deleteTask(widget.floatingTask!.id);
      if (!mounted) return;
      Navigator.of(context).pop();
      return;
    }

    var deleteAll = false;
    if (_groupMembers.length > 1) {
      final scope = await _resolveScopeChoice(isDelete: true);
      if (!mounted || scope == null) return;
      deleteAll = scope == BlockScopeChoice.allInGroup;
    } else {
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
    }

    await ref.read(blockActionsProvider).deleteBlock(
          block: widget.block!,
          groupMembers: _groupMembers,
          deleteAll: deleteAll,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String _screenTitle() {
    if (widget.isEditingFloatingTask) return 'Editar tarefa';
    if (widget.isEditingRoutine) return 'Editar rotina';
    if (widget.duplicateFrom != null) return 'Duplicar rotina';
    return _isRoutineMode ? 'Nova rotina' : 'Nova tarefa';
  }

  String _saveButtonLabel() {
    if (widget.isEditing) return 'Salvar alterações';
    return _isRoutineMode ? 'Criar rotina' : 'Criar tarefa';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showModeToggle = !widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle()),
        actions: [
          if (widget.isEditing)
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
            if (showModeToggle) ...[
              SegmentedButton<ItemFormMode>(
                segments: const [
                  ButtonSegment(
                    value: ItemFormMode.routine,
                    label: Text('Rotina fixa'),
                    icon: Icon(Icons.schedule),
                  ),
                  ButtonSegment(
                    value: ItemFormMode.floatingTask,
                    label: Text('Tarefa solta'),
                    icon: Icon(Icons.checklist),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) {
                  setState(() => _mode = selection.first);
                },
              ),
              const SizedBox(height: 24),
            ],
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: _isRoutineMode ? 'Nome da rotina' : 'Nome da tarefa',
                hintText: _isRoutineMode
                    ? 'Ex: Treino, Trabalho, Ler'
                    : 'Ex: Comprar presente, Ligar pro banco',
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe um nome';
                }
                return null;
              },
            ),
            if (_isRoutineMode) ...[
              const SizedBox(height: 24),
              Text('Horário', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickTime,
                icon: const Icon(Icons.schedule),
                label: Text(
                  formatBlockTime(dateTimeFromTimeOfDay(_selectedTime)),
                ),
              ),
              const SizedBox(height: 24),
              Text('Dias da semana', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              if (!widget.isEditingRoutine)
                Text(
                  'Selecione vários dias para criar a mesma rotina de uma vez.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else if (_groupMembers.length > 1)
                Text(
                  'Alterações podem ser aplicadas a todos os dias desta rotina.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 8),
              WeekdaySelector(
                selectedWeekdays: _selectedWeekdays,
                onChanged: (days) => setState(() => _selectedWeekdays = days),
              ),
              const SizedBox(height: 8),
              if (!widget.isEditingRoutine)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() => _selectedWeekdays = {1, 2, 3, 4, 5});
                    },
                    child: const Text('Seg–Sex'),
                  ),
                ),
            ] else ...[
              const SizedBox(height: 24),
              Text('Prazo (opcional)', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                'Sem prazo, a tarefa aparece todo dia até ser concluída.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Definir prazo'),
                value: _hasDeadline,
                onChanged: (value) {
                  setState(() {
                    _hasDeadline = value;
                    if (!value) _selectedDeadline = null;
                  });
                },
              ),
              if (_hasDeadline)
                OutlinedButton.icon(
                  onPressed: _pickDeadline,
                  icon: const Icon(Icons.event),
                  label: Text(
                    _selectedDeadline != null
                        ? '${_selectedDeadline!.day.toString().padLeft(2, '0')}/'
                            '${_selectedDeadline!.month.toString().padLeft(2, '0')}/'
                            '${_selectedDeadline!.year}'
                        : 'Escolher data',
                  ),
                ),
            ],
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
                  : Text(_saveButtonLabel()),
            ),
          ],
        ),
      ),
    );
  }
}
