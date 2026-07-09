// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutineBlocksTable extends RoutineBlocks
    with TableInfo<$RoutineBlocksTable, RoutineBlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekday,
    startTime,
    title,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineBlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineBlockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineBlockRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
    );
  }

  @override
  $RoutineBlocksTable createAlias(String alias) {
    return $RoutineBlocksTable(attachedDatabase, alias);
  }
}

class RoutineBlockRow extends DataClass implements Insertable<RoutineBlockRow> {
  final String id;
  final int weekday;
  final String startTime;
  final String title;
  final String? category;
  const RoutineBlockRow({
    required this.id,
    required this.weekday,
    required this.startTime,
    required this.title,
    this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['weekday'] = Variable<int>(weekday);
    map['start_time'] = Variable<String>(startTime);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  RoutineBlocksCompanion toCompanion(bool nullToAbsent) {
    return RoutineBlocksCompanion(
      id: Value(id),
      weekday: Value(weekday),
      startTime: Value(startTime),
      title: Value(title),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory RoutineBlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineBlockRow(
      id: serializer.fromJson<String>(json['id']),
      weekday: serializer.fromJson<int>(json['weekday']),
      startTime: serializer.fromJson<String>(json['startTime']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weekday': serializer.toJson<int>(weekday),
      'startTime': serializer.toJson<String>(startTime),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String?>(category),
    };
  }

  RoutineBlockRow copyWith({
    String? id,
    int? weekday,
    String? startTime,
    String? title,
    Value<String?> category = const Value.absent(),
  }) => RoutineBlockRow(
    id: id ?? this.id,
    weekday: weekday ?? this.weekday,
    startTime: startTime ?? this.startTime,
    title: title ?? this.title,
    category: category.present ? category.value : this.category,
  );
  RoutineBlockRow copyWithCompanion(RoutineBlocksCompanion data) {
    return RoutineBlockRow(
      id: data.id.present ? data.id.value : this.id,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineBlockRow(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('title: $title, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekday, startTime, title, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineBlockRow &&
          other.id == this.id &&
          other.weekday == this.weekday &&
          other.startTime == this.startTime &&
          other.title == this.title &&
          other.category == this.category);
}

class RoutineBlocksCompanion extends UpdateCompanion<RoutineBlockRow> {
  final Value<String> id;
  final Value<int> weekday;
  final Value<String> startTime;
  final Value<String> title;
  final Value<String?> category;
  final Value<int> rowid;
  const RoutineBlocksCompanion({
    this.id = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startTime = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineBlocksCompanion.insert({
    required String id,
    required int weekday,
    required String startTime,
    required String title,
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       weekday = Value(weekday),
       startTime = Value(startTime),
       title = Value(title);
  static Insertable<RoutineBlockRow> custom({
    Expression<String>? id,
    Expression<int>? weekday,
    Expression<String>? startTime,
    Expression<String>? title,
    Expression<String>? category,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekday != null) 'weekday': weekday,
      if (startTime != null) 'start_time': startTime,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineBlocksCompanion copyWith({
    Value<String>? id,
    Value<int>? weekday,
    Value<String>? startTime,
    Value<String>? title,
    Value<String?>? category,
    Value<int>? rowid,
  }) {
    return RoutineBlocksCompanion(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      startTime: startTime ?? this.startTime,
      title: title ?? this.title,
      category: category ?? this.category,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineBlocksCompanion(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyCompletionsTable extends DailyCompletions
    with TableInfo<$DailyCompletionsTable, DailyCompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineBlockIdMeta = const VerificationMeta(
    'routineBlockId',
  );
  @override
  late final GeneratedColumn<String> routineBlockId = GeneratedColumn<String>(
    'routine_block_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine_blocks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineBlockId,
    date,
    completed,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyCompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_block_id')) {
      context.handle(
        _routineBlockIdMeta,
        routineBlockId.isAcceptableOrUnknown(
          data['routine_block_id']!,
          _routineBlockIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineBlockIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyCompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCompletionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineBlockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_block_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $DailyCompletionsTable createAlias(String alias) {
    return $DailyCompletionsTable(attachedDatabase, alias);
  }
}

class DailyCompletionRow extends DataClass
    implements Insertable<DailyCompletionRow> {
  final String id;
  final String routineBlockId;
  final String date;
  final bool completed;
  final String? note;
  const DailyCompletionRow({
    required this.id,
    required this.routineBlockId,
    required this.date,
    required this.completed,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_block_id'] = Variable<String>(routineBlockId);
    map['date'] = Variable<String>(date);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DailyCompletionsCompanion toCompanion(bool nullToAbsent) {
    return DailyCompletionsCompanion(
      id: Value(id),
      routineBlockId: Value(routineBlockId),
      date: Value(date),
      completed: Value(completed),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DailyCompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCompletionRow(
      id: serializer.fromJson<String>(json['id']),
      routineBlockId: serializer.fromJson<String>(json['routineBlockId']),
      date: serializer.fromJson<String>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineBlockId': serializer.toJson<String>(routineBlockId),
      'date': serializer.toJson<String>(date),
      'completed': serializer.toJson<bool>(completed),
      'note': serializer.toJson<String?>(note),
    };
  }

  DailyCompletionRow copyWith({
    String? id,
    String? routineBlockId,
    String? date,
    bool? completed,
    Value<String?> note = const Value.absent(),
  }) => DailyCompletionRow(
    id: id ?? this.id,
    routineBlockId: routineBlockId ?? this.routineBlockId,
    date: date ?? this.date,
    completed: completed ?? this.completed,
    note: note.present ? note.value : this.note,
  );
  DailyCompletionRow copyWithCompanion(DailyCompletionsCompanion data) {
    return DailyCompletionRow(
      id: data.id.present ? data.id.value : this.id,
      routineBlockId: data.routineBlockId.present
          ? data.routineBlockId.value
          : this.routineBlockId,
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCompletionRow(')
          ..write('id: $id, ')
          ..write('routineBlockId: $routineBlockId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineBlockId, date, completed, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCompletionRow &&
          other.id == this.id &&
          other.routineBlockId == this.routineBlockId &&
          other.date == this.date &&
          other.completed == this.completed &&
          other.note == this.note);
}

class DailyCompletionsCompanion extends UpdateCompanion<DailyCompletionRow> {
  final Value<String> id;
  final Value<String> routineBlockId;
  final Value<String> date;
  final Value<bool> completed;
  final Value<String?> note;
  final Value<int> rowid;
  const DailyCompletionsCompanion({
    this.id = const Value.absent(),
    this.routineBlockId = const Value.absent(),
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyCompletionsCompanion.insert({
    required String id,
    required String routineBlockId,
    required String date,
    this.completed = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineBlockId = Value(routineBlockId),
       date = Value(date);
  static Insertable<DailyCompletionRow> custom({
    Expression<String>? id,
    Expression<String>? routineBlockId,
    Expression<String>? date,
    Expression<bool>? completed,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineBlockId != null) 'routine_block_id': routineBlockId,
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyCompletionsCompanion copyWith({
    Value<String>? id,
    Value<String>? routineBlockId,
    Value<String>? date,
    Value<bool>? completed,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return DailyCompletionsCompanion(
      id: id ?? this.id,
      routineBlockId: routineBlockId ?? this.routineBlockId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineBlockId.present) {
      map['routine_block_id'] = Variable<String>(routineBlockId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('routineBlockId: $routineBlockId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutineBlocksTable routineBlocks = $RoutineBlocksTable(this);
  late final $DailyCompletionsTable dailyCompletions = $DailyCompletionsTable(
    this,
  );
  late final Index idxCompletionBlockDate = Index(
    'idx_completion_block_date',
    'CREATE UNIQUE INDEX idx_completion_block_date ON daily_completions (routine_block_id, date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routineBlocks,
    dailyCompletions,
    idxCompletionBlockDate,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_blocks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('daily_completions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$RoutineBlocksTableCreateCompanionBuilder =
    RoutineBlocksCompanion Function({
      required String id,
      required int weekday,
      required String startTime,
      required String title,
      Value<String?> category,
      Value<int> rowid,
    });
typedef $$RoutineBlocksTableUpdateCompanionBuilder =
    RoutineBlocksCompanion Function({
      Value<String> id,
      Value<int> weekday,
      Value<String> startTime,
      Value<String> title,
      Value<String?> category,
      Value<int> rowid,
    });

final class $$RoutineBlocksTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutineBlocksTable, RoutineBlockRow> {
  $$RoutineBlocksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DailyCompletionsTable, List<DailyCompletionRow>>
  _dailyCompletionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyCompletions,
    aliasName: 'routine_blocks__id__daily_completions__routine_block_id',
  );

  $$DailyCompletionsTableProcessedTableManager get dailyCompletionsRefs {
    final manager = $$DailyCompletionsTableTableManager(
      $_db,
      $_db.dailyCompletions,
    ).filter((f) => f.routineBlockId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineBlocksTable> {
  $$RoutineBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dailyCompletionsRefs(
    Expression<bool> Function($$DailyCompletionsTableFilterComposer f) f,
  ) {
    final $$DailyCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyCompletions,
      getReferencedColumn: (t) => t.routineBlockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.dailyCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineBlocksTable> {
  $$RoutineBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutineBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineBlocksTable> {
  $$RoutineBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  Expression<T> dailyCompletionsRefs<T extends Object>(
    Expression<T> Function($$DailyCompletionsTableAnnotationComposer a) f,
  ) {
    final $$DailyCompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyCompletions,
      getReferencedColumn: (t) => t.routineBlockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyCompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineBlocksTable,
          RoutineBlockRow,
          $$RoutineBlocksTableFilterComposer,
          $$RoutineBlocksTableOrderingComposer,
          $$RoutineBlocksTableAnnotationComposer,
          $$RoutineBlocksTableCreateCompanionBuilder,
          $$RoutineBlocksTableUpdateCompanionBuilder,
          (RoutineBlockRow, $$RoutineBlocksTableReferences),
          RoutineBlockRow,
          PrefetchHooks Function({bool dailyCompletionsRefs})
        > {
  $$RoutineBlocksTableTableManager(_$AppDatabase db, $RoutineBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineBlocksCompanion(
                id: id,
                weekday: weekday,
                startTime: startTime,
                title: title,
                category: category,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int weekday,
                required String startTime,
                required String title,
                Value<String?> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineBlocksCompanion.insert(
                id: id,
                weekday: weekday,
                startTime: startTime,
                title: title,
                category: category,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyCompletionsRefs) db.dailyCompletions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyCompletionsRefs)
                    await $_getPrefetchedData<
                      RoutineBlockRow,
                      $RoutineBlocksTable,
                      DailyCompletionRow
                    >(
                      currentTable: table,
                      referencedTable: $$RoutineBlocksTableReferences
                          ._dailyCompletionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RoutineBlocksTableReferences(
                            db,
                            table,
                            p0,
                          ).dailyCompletionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.routineBlockId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutineBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineBlocksTable,
      RoutineBlockRow,
      $$RoutineBlocksTableFilterComposer,
      $$RoutineBlocksTableOrderingComposer,
      $$RoutineBlocksTableAnnotationComposer,
      $$RoutineBlocksTableCreateCompanionBuilder,
      $$RoutineBlocksTableUpdateCompanionBuilder,
      (RoutineBlockRow, $$RoutineBlocksTableReferences),
      RoutineBlockRow,
      PrefetchHooks Function({bool dailyCompletionsRefs})
    >;
typedef $$DailyCompletionsTableCreateCompanionBuilder =
    DailyCompletionsCompanion Function({
      required String id,
      required String routineBlockId,
      required String date,
      Value<bool> completed,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$DailyCompletionsTableUpdateCompanionBuilder =
    DailyCompletionsCompanion Function({
      Value<String> id,
      Value<String> routineBlockId,
      Value<String> date,
      Value<bool> completed,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$DailyCompletionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyCompletionsTable,
          DailyCompletionRow
        > {
  $$DailyCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineBlocksTable _routineBlockIdTable(_$AppDatabase db) => db
      .routineBlocks
      .createAlias('daily_completions__routine_block_id__routine_blocks__id');

  $$RoutineBlocksTableProcessedTableManager get routineBlockId {
    final $_column = $_itemColumn<String>('routine_block_id')!;

    final manager = $$RoutineBlocksTableTableManager(
      $_db,
      $_db.routineBlocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineBlockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyCompletionsTable> {
  $$DailyCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutineBlocksTableFilterComposer get routineBlockId {
    final $$RoutineBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineBlockId,
      referencedTable: $db.routineBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineBlocksTableFilterComposer(
            $db: $db,
            $table: $db.routineBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyCompletionsTable> {
  $$DailyCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutineBlocksTableOrderingComposer get routineBlockId {
    final $$RoutineBlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineBlockId,
      referencedTable: $db.routineBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineBlocksTableOrderingComposer(
            $db: $db,
            $table: $db.routineBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyCompletionsTable> {
  $$DailyCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$RoutineBlocksTableAnnotationComposer get routineBlockId {
    final $$RoutineBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineBlockId,
      referencedTable: $db.routineBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.routineBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyCompletionsTable,
          DailyCompletionRow,
          $$DailyCompletionsTableFilterComposer,
          $$DailyCompletionsTableOrderingComposer,
          $$DailyCompletionsTableAnnotationComposer,
          $$DailyCompletionsTableCreateCompanionBuilder,
          $$DailyCompletionsTableUpdateCompanionBuilder,
          (DailyCompletionRow, $$DailyCompletionsTableReferences),
          DailyCompletionRow,
          PrefetchHooks Function({bool routineBlockId})
        > {
  $$DailyCompletionsTableTableManager(
    _$AppDatabase db,
    $DailyCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineBlockId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCompletionsCompanion(
                id: id,
                routineBlockId: routineBlockId,
                date: date,
                completed: completed,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routineBlockId,
                required String date,
                Value<bool> completed = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCompletionsCompanion.insert(
                id: id,
                routineBlockId: routineBlockId,
                date: date,
                completed: completed,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineBlockId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineBlockId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.routineBlockId,
                                referencedTable:
                                    $$DailyCompletionsTableReferences
                                        ._routineBlockIdTable(db),
                                referencedColumn:
                                    $$DailyCompletionsTableReferences
                                        ._routineBlockIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyCompletionsTable,
      DailyCompletionRow,
      $$DailyCompletionsTableFilterComposer,
      $$DailyCompletionsTableOrderingComposer,
      $$DailyCompletionsTableAnnotationComposer,
      $$DailyCompletionsTableCreateCompanionBuilder,
      $$DailyCompletionsTableUpdateCompanionBuilder,
      (DailyCompletionRow, $$DailyCompletionsTableReferences),
      DailyCompletionRow,
      PrefetchHooks Function({bool routineBlockId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutineBlocksTableTableManager get routineBlocks =>
      $$RoutineBlocksTableTableManager(_db, _db.routineBlocks);
  $$DailyCompletionsTableTableManager get dailyCompletions =>
      $$DailyCompletionsTableTableManager(_db, _db.dailyCompletions);
}
