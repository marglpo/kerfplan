// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialMeta = const VerificationMeta(
    'material',
  );
  @override
  late final GeneratedColumn<String> material = GeneratedColumn<String>(
    'material',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _inventoryModeMeta = const VerificationMeta(
    'inventoryMode',
  );
  @override
  late final GeneratedColumn<String> inventoryMode = GeneratedColumn<String>(
    'inventory_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayUnitMeta = const VerificationMeta(
    'displayUnit',
  );
  @override
  late final GeneratedColumn<String> displayUnit = GeneratedColumn<String>(
    'display_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kerfTicksMeta = const VerificationMeta(
    'kerfTicks',
  );
  @override
  late final GeneratedColumn<int> kerfTicks = GeneratedColumn<int>(
    'kerf_ticks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTrimTicksMeta = const VerificationMeta(
    'endTrimTicks',
  );
  @override
  late final GeneratedColumn<int> endTrimTicks = GeneratedColumn<int>(
    'end_trim_ticks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minReusableTicksMeta = const VerificationMeta(
    'minReusableTicks',
  );
  @override
  late final GeneratedColumn<int> minReusableTicks = GeneratedColumn<int>(
    'min_reusable_ticks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buyStockLengthTicksMeta =
      const VerificationMeta('buyStockLengthTicks');
  @override
  late final GeneratedColumn<int> buyStockLengthTicks = GeneratedColumn<int>(
    'buy_stock_length_ticks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastRunIdMeta = const VerificationMeta(
    'lastRunId',
  );
  @override
  late final GeneratedColumn<String> lastRunId = GeneratedColumn<String>(
    'last_run_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    material,
    note,
    inventoryMode,
    displayUnit,
    kerfTicks,
    endTrimTicks,
    minReusableTicks,
    buyStockLengthTicks,
    revision,
    lastRunId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('material')) {
      context.handle(
        _materialMeta,
        material.isAcceptableOrUnknown(data['material']!, _materialMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('inventory_mode')) {
      context.handle(
        _inventoryModeMeta,
        inventoryMode.isAcceptableOrUnknown(
          data['inventory_mode']!,
          _inventoryModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inventoryModeMeta);
    }
    if (data.containsKey('display_unit')) {
      context.handle(
        _displayUnitMeta,
        displayUnit.isAcceptableOrUnknown(
          data['display_unit']!,
          _displayUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayUnitMeta);
    }
    if (data.containsKey('kerf_ticks')) {
      context.handle(
        _kerfTicksMeta,
        kerfTicks.isAcceptableOrUnknown(data['kerf_ticks']!, _kerfTicksMeta),
      );
    } else if (isInserting) {
      context.missing(_kerfTicksMeta);
    }
    if (data.containsKey('end_trim_ticks')) {
      context.handle(
        _endTrimTicksMeta,
        endTrimTicks.isAcceptableOrUnknown(
          data['end_trim_ticks']!,
          _endTrimTicksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endTrimTicksMeta);
    }
    if (data.containsKey('min_reusable_ticks')) {
      context.handle(
        _minReusableTicksMeta,
        minReusableTicks.isAcceptableOrUnknown(
          data['min_reusable_ticks']!,
          _minReusableTicksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minReusableTicksMeta);
    }
    if (data.containsKey('buy_stock_length_ticks')) {
      context.handle(
        _buyStockLengthTicksMeta,
        buyStockLengthTicks.isAcceptableOrUnknown(
          data['buy_stock_length_ticks']!,
          _buyStockLengthTicksMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('last_run_id')) {
      context.handle(
        _lastRunIdMeta,
        lastRunId.isAcceptableOrUnknown(data['last_run_id']!, _lastRunIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      material: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      inventoryMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inventory_mode'],
      )!,
      displayUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_unit'],
      )!,
      kerfTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kerf_ticks'],
      )!,
      endTrimTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_trim_ticks'],
      )!,
      minReusableTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_reusable_ticks'],
      )!,
      buyStockLengthTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}buy_stock_length_ticks'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      lastRunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_run_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String? material;
  final String? note;

  /// Supported product modes: fixed, buy.
  final String inventoryMode;

  /// Supported units: mm, cm, m, inch, ftIn.
  final String displayUnit;
  final int kerfTicks;
  final int endTrimTicks;
  final int minReusableTicks;
  final int? buyStockLengthTicks;
  final int revision;
  final String? lastRunId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Project({
    required this.id,
    required this.name,
    this.material,
    this.note,
    required this.inventoryMode,
    required this.displayUnit,
    required this.kerfTicks,
    required this.endTrimTicks,
    required this.minReusableTicks,
    this.buyStockLengthTicks,
    required this.revision,
    this.lastRunId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || material != null) {
      map['material'] = Variable<String>(material);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['inventory_mode'] = Variable<String>(inventoryMode);
    map['display_unit'] = Variable<String>(displayUnit);
    map['kerf_ticks'] = Variable<int>(kerfTicks);
    map['end_trim_ticks'] = Variable<int>(endTrimTicks);
    map['min_reusable_ticks'] = Variable<int>(minReusableTicks);
    if (!nullToAbsent || buyStockLengthTicks != null) {
      map['buy_stock_length_ticks'] = Variable<int>(buyStockLengthTicks);
    }
    map['revision'] = Variable<int>(revision);
    if (!nullToAbsent || lastRunId != null) {
      map['last_run_id'] = Variable<String>(lastRunId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      material: material == null && nullToAbsent
          ? const Value.absent()
          : Value(material),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      inventoryMode: Value(inventoryMode),
      displayUnit: Value(displayUnit),
      kerfTicks: Value(kerfTicks),
      endTrimTicks: Value(endTrimTicks),
      minReusableTicks: Value(minReusableTicks),
      buyStockLengthTicks: buyStockLengthTicks == null && nullToAbsent
          ? const Value.absent()
          : Value(buyStockLengthTicks),
      revision: Value(revision),
      lastRunId: lastRunId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRunId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      material: serializer.fromJson<String?>(json['material']),
      note: serializer.fromJson<String?>(json['note']),
      inventoryMode: serializer.fromJson<String>(json['inventoryMode']),
      displayUnit: serializer.fromJson<String>(json['displayUnit']),
      kerfTicks: serializer.fromJson<int>(json['kerfTicks']),
      endTrimTicks: serializer.fromJson<int>(json['endTrimTicks']),
      minReusableTicks: serializer.fromJson<int>(json['minReusableTicks']),
      buyStockLengthTicks: serializer.fromJson<int?>(
        json['buyStockLengthTicks'],
      ),
      revision: serializer.fromJson<int>(json['revision']),
      lastRunId: serializer.fromJson<String?>(json['lastRunId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'material': serializer.toJson<String?>(material),
      'note': serializer.toJson<String?>(note),
      'inventoryMode': serializer.toJson<String>(inventoryMode),
      'displayUnit': serializer.toJson<String>(displayUnit),
      'kerfTicks': serializer.toJson<int>(kerfTicks),
      'endTrimTicks': serializer.toJson<int>(endTrimTicks),
      'minReusableTicks': serializer.toJson<int>(minReusableTicks),
      'buyStockLengthTicks': serializer.toJson<int?>(buyStockLengthTicks),
      'revision': serializer.toJson<int>(revision),
      'lastRunId': serializer.toJson<String?>(lastRunId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    Value<String?> material = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? inventoryMode,
    String? displayUnit,
    int? kerfTicks,
    int? endTrimTicks,
    int? minReusableTicks,
    Value<int?> buyStockLengthTicks = const Value.absent(),
    int? revision,
    Value<String?> lastRunId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    material: material.present ? material.value : this.material,
    note: note.present ? note.value : this.note,
    inventoryMode: inventoryMode ?? this.inventoryMode,
    displayUnit: displayUnit ?? this.displayUnit,
    kerfTicks: kerfTicks ?? this.kerfTicks,
    endTrimTicks: endTrimTicks ?? this.endTrimTicks,
    minReusableTicks: minReusableTicks ?? this.minReusableTicks,
    buyStockLengthTicks: buyStockLengthTicks.present
        ? buyStockLengthTicks.value
        : this.buyStockLengthTicks,
    revision: revision ?? this.revision,
    lastRunId: lastRunId.present ? lastRunId.value : this.lastRunId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      material: data.material.present ? data.material.value : this.material,
      note: data.note.present ? data.note.value : this.note,
      inventoryMode: data.inventoryMode.present
          ? data.inventoryMode.value
          : this.inventoryMode,
      displayUnit: data.displayUnit.present
          ? data.displayUnit.value
          : this.displayUnit,
      kerfTicks: data.kerfTicks.present ? data.kerfTicks.value : this.kerfTicks,
      endTrimTicks: data.endTrimTicks.present
          ? data.endTrimTicks.value
          : this.endTrimTicks,
      minReusableTicks: data.minReusableTicks.present
          ? data.minReusableTicks.value
          : this.minReusableTicks,
      buyStockLengthTicks: data.buyStockLengthTicks.present
          ? data.buyStockLengthTicks.value
          : this.buyStockLengthTicks,
      revision: data.revision.present ? data.revision.value : this.revision,
      lastRunId: data.lastRunId.present ? data.lastRunId.value : this.lastRunId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('material: $material, ')
          ..write('note: $note, ')
          ..write('inventoryMode: $inventoryMode, ')
          ..write('displayUnit: $displayUnit, ')
          ..write('kerfTicks: $kerfTicks, ')
          ..write('endTrimTicks: $endTrimTicks, ')
          ..write('minReusableTicks: $minReusableTicks, ')
          ..write('buyStockLengthTicks: $buyStockLengthTicks, ')
          ..write('revision: $revision, ')
          ..write('lastRunId: $lastRunId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    material,
    note,
    inventoryMode,
    displayUnit,
    kerfTicks,
    endTrimTicks,
    minReusableTicks,
    buyStockLengthTicks,
    revision,
    lastRunId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.material == this.material &&
          other.note == this.note &&
          other.inventoryMode == this.inventoryMode &&
          other.displayUnit == this.displayUnit &&
          other.kerfTicks == this.kerfTicks &&
          other.endTrimTicks == this.endTrimTicks &&
          other.minReusableTicks == this.minReusableTicks &&
          other.buyStockLengthTicks == this.buyStockLengthTicks &&
          other.revision == this.revision &&
          other.lastRunId == this.lastRunId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> material;
  final Value<String?> note;
  final Value<String> inventoryMode;
  final Value<String> displayUnit;
  final Value<int> kerfTicks;
  final Value<int> endTrimTicks;
  final Value<int> minReusableTicks;
  final Value<int?> buyStockLengthTicks;
  final Value<int> revision;
  final Value<String?> lastRunId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.material = const Value.absent(),
    this.note = const Value.absent(),
    this.inventoryMode = const Value.absent(),
    this.displayUnit = const Value.absent(),
    this.kerfTicks = const Value.absent(),
    this.endTrimTicks = const Value.absent(),
    this.minReusableTicks = const Value.absent(),
    this.buyStockLengthTicks = const Value.absent(),
    this.revision = const Value.absent(),
    this.lastRunId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.material = const Value.absent(),
    this.note = const Value.absent(),
    required String inventoryMode,
    required String displayUnit,
    required int kerfTicks,
    required int endTrimTicks,
    required int minReusableTicks,
    this.buyStockLengthTicks = const Value.absent(),
    this.revision = const Value.absent(),
    this.lastRunId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       inventoryMode = Value(inventoryMode),
       displayUnit = Value(displayUnit),
       kerfTicks = Value(kerfTicks),
       endTrimTicks = Value(endTrimTicks),
       minReusableTicks = Value(minReusableTicks),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? material,
    Expression<String>? note,
    Expression<String>? inventoryMode,
    Expression<String>? displayUnit,
    Expression<int>? kerfTicks,
    Expression<int>? endTrimTicks,
    Expression<int>? minReusableTicks,
    Expression<int>? buyStockLengthTicks,
    Expression<int>? revision,
    Expression<String>? lastRunId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (material != null) 'material': material,
      if (note != null) 'note': note,
      if (inventoryMode != null) 'inventory_mode': inventoryMode,
      if (displayUnit != null) 'display_unit': displayUnit,
      if (kerfTicks != null) 'kerf_ticks': kerfTicks,
      if (endTrimTicks != null) 'end_trim_ticks': endTrimTicks,
      if (minReusableTicks != null) 'min_reusable_ticks': minReusableTicks,
      if (buyStockLengthTicks != null)
        'buy_stock_length_ticks': buyStockLengthTicks,
      if (revision != null) 'revision': revision,
      if (lastRunId != null) 'last_run_id': lastRunId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? material,
    Value<String?>? note,
    Value<String>? inventoryMode,
    Value<String>? displayUnit,
    Value<int>? kerfTicks,
    Value<int>? endTrimTicks,
    Value<int>? minReusableTicks,
    Value<int?>? buyStockLengthTicks,
    Value<int>? revision,
    Value<String?>? lastRunId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      material: material ?? this.material,
      note: note ?? this.note,
      inventoryMode: inventoryMode ?? this.inventoryMode,
      displayUnit: displayUnit ?? this.displayUnit,
      kerfTicks: kerfTicks ?? this.kerfTicks,
      endTrimTicks: endTrimTicks ?? this.endTrimTicks,
      minReusableTicks: minReusableTicks ?? this.minReusableTicks,
      buyStockLengthTicks: buyStockLengthTicks ?? this.buyStockLengthTicks,
      revision: revision ?? this.revision,
      lastRunId: lastRunId ?? this.lastRunId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (material.present) {
      map['material'] = Variable<String>(material.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (inventoryMode.present) {
      map['inventory_mode'] = Variable<String>(inventoryMode.value);
    }
    if (displayUnit.present) {
      map['display_unit'] = Variable<String>(displayUnit.value);
    }
    if (kerfTicks.present) {
      map['kerf_ticks'] = Variable<int>(kerfTicks.value);
    }
    if (endTrimTicks.present) {
      map['end_trim_ticks'] = Variable<int>(endTrimTicks.value);
    }
    if (minReusableTicks.present) {
      map['min_reusable_ticks'] = Variable<int>(minReusableTicks.value);
    }
    if (buyStockLengthTicks.present) {
      map['buy_stock_length_ticks'] = Variable<int>(buyStockLengthTicks.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (lastRunId.present) {
      map['last_run_id'] = Variable<String>(lastRunId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('material: $material, ')
          ..write('note: $note, ')
          ..write('inventoryMode: $inventoryMode, ')
          ..write('displayUnit: $displayUnit, ')
          ..write('kerfTicks: $kerfTicks, ')
          ..write('endTrimTicks: $endTrimTicks, ')
          ..write('minReusableTicks: $minReusableTicks, ')
          ..write('buyStockLengthTicks: $buyStockLengthTicks, ')
          ..write('revision: $revision, ')
          ..write('lastRunId: $lastRunId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockLinesTable extends StockLines
    with TableInfo<$StockLinesTable, StockLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lengthTicksMeta = const VerificationMeta(
    'lengthTicks',
  );
  @override
  late final GeneratedColumn<int> lengthTicks = GeneratedColumn<int>(
    'length_ticks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    lengthTicks,
    quantity,
    label,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('length_ticks')) {
      context.handle(
        _lengthTicksMeta,
        lengthTicks.isAcceptableOrUnknown(
          data['length_ticks']!,
          _lengthTicksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lengthTicksMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      lengthTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}length_ticks'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StockLinesTable createAlias(String alias) {
    return $StockLinesTable(attachedDatabase, alias);
  }
}

class StockLine extends DataClass implements Insertable<StockLine> {
  final String id;
  final String projectId;
  final int lengthTicks;
  final int quantity;
  final String? label;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StockLine({
    required this.id,
    required this.projectId,
    required this.lengthTicks,
    required this.quantity,
    this.label,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['length_ticks'] = Variable<int>(lengthTicks);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StockLinesCompanion toCompanion(bool nullToAbsent) {
    return StockLinesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      lengthTicks: Value(lengthTicks),
      quantity: Value(quantity),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StockLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockLine(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      lengthTicks: serializer.fromJson<int>(json['lengthTicks']),
      quantity: serializer.fromJson<int>(json['quantity']),
      label: serializer.fromJson<String?>(json['label']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'lengthTicks': serializer.toJson<int>(lengthTicks),
      'quantity': serializer.toJson<int>(quantity),
      'label': serializer.toJson<String?>(label),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StockLine copyWith({
    String? id,
    String? projectId,
    int? lengthTicks,
    int? quantity,
    Value<String?> label = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StockLine(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    lengthTicks: lengthTicks ?? this.lengthTicks,
    quantity: quantity ?? this.quantity,
    label: label.present ? label.value : this.label,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StockLine copyWithCompanion(StockLinesCompanion data) {
    return StockLine(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      lengthTicks: data.lengthTicks.present
          ? data.lengthTicks.value
          : this.lengthTicks,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      label: data.label.present ? data.label.value : this.label,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockLine(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('lengthTicks: $lengthTicks, ')
          ..write('quantity: $quantity, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    lengthTicks,
    quantity,
    label,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockLine &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.lengthTicks == this.lengthTicks &&
          other.quantity == this.quantity &&
          other.label == this.label &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StockLinesCompanion extends UpdateCompanion<StockLine> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<int> lengthTicks;
  final Value<int> quantity;
  final Value<String?> label;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StockLinesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.lengthTicks = const Value.absent(),
    this.quantity = const Value.absent(),
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockLinesCompanion.insert({
    required String id,
    required String projectId,
    required int lengthTicks,
    required int quantity,
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       lengthTicks = Value(lengthTicks),
       quantity = Value(quantity),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StockLine> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<int>? lengthTicks,
    Expression<int>? quantity,
    Expression<String>? label,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (lengthTicks != null) 'length_ticks': lengthTicks,
      if (quantity != null) 'quantity': quantity,
      if (label != null) 'label': label,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<int>? lengthTicks,
    Value<int>? quantity,
    Value<String?>? label,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StockLinesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      lengthTicks: lengthTicks ?? this.lengthTicks,
      quantity: quantity ?? this.quantity,
      label: label ?? this.label,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (lengthTicks.present) {
      map['length_ticks'] = Variable<int>(lengthTicks.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockLinesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('lengthTicks: $lengthTicks, ')
          ..write('quantity: $quantity, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartLinesTable extends PartLines
    with TableInfo<$PartLinesTable, PartLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lengthTicksMeta = const VerificationMeta(
    'lengthTicks',
  );
  @override
  late final GeneratedColumn<int> lengthTicks = GeneratedColumn<int>(
    'length_ticks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    lengthTicks,
    quantity,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('length_ticks')) {
      context.handle(
        _lengthTicksMeta,
        lengthTicks.isAcceptableOrUnknown(
          data['length_ticks']!,
          _lengthTicksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lengthTicksMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      lengthTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}length_ticks'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PartLinesTable createAlias(String alias) {
    return $PartLinesTable(attachedDatabase, alias);
  }
}

class PartLine extends DataClass implements Insertable<PartLine> {
  final String id;
  final String projectId;
  final String? name;
  final int lengthTicks;
  final int quantity;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PartLine({
    required this.id,
    required this.projectId,
    this.name,
    required this.lengthTicks,
    required this.quantity,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['length_ticks'] = Variable<int>(lengthTicks);
    map['quantity'] = Variable<int>(quantity);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartLinesCompanion toCompanion(bool nullToAbsent) {
    return PartLinesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      lengthTicks: Value(lengthTicks),
      quantity: Value(quantity),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PartLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartLine(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String?>(json['name']),
      lengthTicks: serializer.fromJson<int>(json['lengthTicks']),
      quantity: serializer.fromJson<int>(json['quantity']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String?>(name),
      'lengthTicks': serializer.toJson<int>(lengthTicks),
      'quantity': serializer.toJson<int>(quantity),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PartLine copyWith({
    String? id,
    String? projectId,
    Value<String?> name = const Value.absent(),
    int? lengthTicks,
    int? quantity,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartLine(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name.present ? name.value : this.name,
    lengthTicks: lengthTicks ?? this.lengthTicks,
    quantity: quantity ?? this.quantity,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PartLine copyWithCompanion(PartLinesCompanion data) {
    return PartLine(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      lengthTicks: data.lengthTicks.present
          ? data.lengthTicks.value
          : this.lengthTicks,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartLine(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('lengthTicks: $lengthTicks, ')
          ..write('quantity: $quantity, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    lengthTicks,
    quantity,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartLine &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.lengthTicks == this.lengthTicks &&
          other.quantity == this.quantity &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartLinesCompanion extends UpdateCompanion<PartLine> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String?> name;
  final Value<int> lengthTicks;
  final Value<int> quantity;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PartLinesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.lengthTicks = const Value.absent(),
    this.quantity = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartLinesCompanion.insert({
    required String id,
    required String projectId,
    this.name = const Value.absent(),
    required int lengthTicks,
    required int quantity,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       lengthTicks = Value(lengthTicks),
       quantity = Value(quantity),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PartLine> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<int>? lengthTicks,
    Expression<int>? quantity,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (lengthTicks != null) 'length_ticks': lengthTicks,
      if (quantity != null) 'quantity': quantity,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String?>? name,
    Value<int>? lengthTicks,
    Value<int>? quantity,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PartLinesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      lengthTicks: lengthTicks ?? this.lengthTicks,
      quantity: quantity ?? this.quantity,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lengthTicks.present) {
      map['length_ticks'] = Variable<int>(lengthTicks.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartLinesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('lengthTicks: $lengthTicks, ')
          ..write('quantity: $quantity, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultDisplayUnitMeta =
      const VerificationMeta('defaultDisplayUnit');
  @override
  late final GeneratedColumn<String> defaultDisplayUnit =
      GeneratedColumn<String>(
        'default_display_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _defaultKerfTicksMeta = const VerificationMeta(
    'defaultKerfTicks',
  );
  @override
  late final GeneratedColumn<int> defaultKerfTicks = GeneratedColumn<int>(
    'default_kerf_ticks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultReusableTicksMeta =
      const VerificationMeta('defaultReusableTicks');
  @override
  late final GeneratedColumn<int> defaultReusableTicks = GeneratedColumn<int>(
    'default_reusable_ticks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeTagMeta = const VerificationMeta(
    'localeTag',
  );
  @override
  late final GeneratedColumn<String> localeTag = GeneratedColumn<String>(
    'locale_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measurementSystemMeta = const VerificationMeta(
    'measurementSystem',
  );
  @override
  late final GeneratedColumn<String> measurementSystem =
      GeneratedColumn<String>(
        'measurement_system',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultDisplayUnit,
    defaultKerfTicks,
    defaultReusableTicks,
    themeMode,
    localeTag,
    measurementSystem,
    onboardingCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('default_display_unit')) {
      context.handle(
        _defaultDisplayUnitMeta,
        defaultDisplayUnit.isAcceptableOrUnknown(
          data['default_display_unit']!,
          _defaultDisplayUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultDisplayUnitMeta);
    }
    if (data.containsKey('default_kerf_ticks')) {
      context.handle(
        _defaultKerfTicksMeta,
        defaultKerfTicks.isAcceptableOrUnknown(
          data['default_kerf_ticks']!,
          _defaultKerfTicksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultKerfTicksMeta);
    }
    if (data.containsKey('default_reusable_ticks')) {
      context.handle(
        _defaultReusableTicksMeta,
        defaultReusableTicks.isAcceptableOrUnknown(
          data['default_reusable_ticks']!,
          _defaultReusableTicksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultReusableTicksMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('locale_tag')) {
      context.handle(
        _localeTagMeta,
        localeTag.isAcceptableOrUnknown(data['locale_tag']!, _localeTagMeta),
      );
    }
    if (data.containsKey('measurement_system')) {
      context.handle(
        _measurementSystemMeta,
        measurementSystem.isAcceptableOrUnknown(
          data['measurement_system']!,
          _measurementSystemMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      defaultDisplayUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_display_unit'],
      )!,
      defaultKerfTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_kerf_ticks'],
      )!,
      defaultReusableTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_reusable_ticks'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      localeTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_tag'],
      ),
      measurementSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_system'],
      ),
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String defaultDisplayUnit;
  final int defaultKerfTicks;
  final int defaultReusableTicks;
  final String themeMode;
  final String? localeTag;
  final String? measurementSystem;
  final bool onboardingCompleted;
  const AppSetting({
    required this.id,
    required this.defaultDisplayUnit,
    required this.defaultKerfTicks,
    required this.defaultReusableTicks,
    required this.themeMode,
    this.localeTag,
    this.measurementSystem,
    required this.onboardingCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['default_display_unit'] = Variable<String>(defaultDisplayUnit);
    map['default_kerf_ticks'] = Variable<int>(defaultKerfTicks);
    map['default_reusable_ticks'] = Variable<int>(defaultReusableTicks);
    map['theme_mode'] = Variable<String>(themeMode);
    if (!nullToAbsent || localeTag != null) {
      map['locale_tag'] = Variable<String>(localeTag);
    }
    if (!nullToAbsent || measurementSystem != null) {
      map['measurement_system'] = Variable<String>(measurementSystem);
    }
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      defaultDisplayUnit: Value(defaultDisplayUnit),
      defaultKerfTicks: Value(defaultKerfTicks),
      defaultReusableTicks: Value(defaultReusableTicks),
      themeMode: Value(themeMode),
      localeTag: localeTag == null && nullToAbsent
          ? const Value.absent()
          : Value(localeTag),
      measurementSystem: measurementSystem == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementSystem),
      onboardingCompleted: Value(onboardingCompleted),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      defaultDisplayUnit: serializer.fromJson<String>(
        json['defaultDisplayUnit'],
      ),
      defaultKerfTicks: serializer.fromJson<int>(json['defaultKerfTicks']),
      defaultReusableTicks: serializer.fromJson<int>(
        json['defaultReusableTicks'],
      ),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      localeTag: serializer.fromJson<String?>(json['localeTag']),
      measurementSystem: serializer.fromJson<String?>(
        json['measurementSystem'],
      ),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'defaultDisplayUnit': serializer.toJson<String>(defaultDisplayUnit),
      'defaultKerfTicks': serializer.toJson<int>(defaultKerfTicks),
      'defaultReusableTicks': serializer.toJson<int>(defaultReusableTicks),
      'themeMode': serializer.toJson<String>(themeMode),
      'localeTag': serializer.toJson<String?>(localeTag),
      'measurementSystem': serializer.toJson<String?>(measurementSystem),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
    };
  }

  AppSetting copyWith({
    int? id,
    String? defaultDisplayUnit,
    int? defaultKerfTicks,
    int? defaultReusableTicks,
    String? themeMode,
    Value<String?> localeTag = const Value.absent(),
    Value<String?> measurementSystem = const Value.absent(),
    bool? onboardingCompleted,
  }) => AppSetting(
    id: id ?? this.id,
    defaultDisplayUnit: defaultDisplayUnit ?? this.defaultDisplayUnit,
    defaultKerfTicks: defaultKerfTicks ?? this.defaultKerfTicks,
    defaultReusableTicks: defaultReusableTicks ?? this.defaultReusableTicks,
    themeMode: themeMode ?? this.themeMode,
    localeTag: localeTag.present ? localeTag.value : this.localeTag,
    measurementSystem: measurementSystem.present
        ? measurementSystem.value
        : this.measurementSystem,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      defaultDisplayUnit: data.defaultDisplayUnit.present
          ? data.defaultDisplayUnit.value
          : this.defaultDisplayUnit,
      defaultKerfTicks: data.defaultKerfTicks.present
          ? data.defaultKerfTicks.value
          : this.defaultKerfTicks,
      defaultReusableTicks: data.defaultReusableTicks.present
          ? data.defaultReusableTicks.value
          : this.defaultReusableTicks,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      localeTag: data.localeTag.present ? data.localeTag.value : this.localeTag,
      measurementSystem: data.measurementSystem.present
          ? data.measurementSystem.value
          : this.measurementSystem,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('defaultDisplayUnit: $defaultDisplayUnit, ')
          ..write('defaultKerfTicks: $defaultKerfTicks, ')
          ..write('defaultReusableTicks: $defaultReusableTicks, ')
          ..write('themeMode: $themeMode, ')
          ..write('localeTag: $localeTag, ')
          ..write('measurementSystem: $measurementSystem, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultDisplayUnit,
    defaultKerfTicks,
    defaultReusableTicks,
    themeMode,
    localeTag,
    measurementSystem,
    onboardingCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.defaultDisplayUnit == this.defaultDisplayUnit &&
          other.defaultKerfTicks == this.defaultKerfTicks &&
          other.defaultReusableTicks == this.defaultReusableTicks &&
          other.themeMode == this.themeMode &&
          other.localeTag == this.localeTag &&
          other.measurementSystem == this.measurementSystem &&
          other.onboardingCompleted == this.onboardingCompleted);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> defaultDisplayUnit;
  final Value<int> defaultKerfTicks;
  final Value<int> defaultReusableTicks;
  final Value<String> themeMode;
  final Value<String?> localeTag;
  final Value<String?> measurementSystem;
  final Value<bool> onboardingCompleted;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.defaultDisplayUnit = const Value.absent(),
    this.defaultKerfTicks = const Value.absent(),
    this.defaultReusableTicks = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.localeTag = const Value.absent(),
    this.measurementSystem = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String defaultDisplayUnit,
    required int defaultKerfTicks,
    required int defaultReusableTicks,
    required String themeMode,
    this.localeTag = const Value.absent(),
    this.measurementSystem = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  }) : defaultDisplayUnit = Value(defaultDisplayUnit),
       defaultKerfTicks = Value(defaultKerfTicks),
       defaultReusableTicks = Value(defaultReusableTicks),
       themeMode = Value(themeMode);
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? defaultDisplayUnit,
    Expression<int>? defaultKerfTicks,
    Expression<int>? defaultReusableTicks,
    Expression<String>? themeMode,
    Expression<String>? localeTag,
    Expression<String>? measurementSystem,
    Expression<bool>? onboardingCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultDisplayUnit != null)
        'default_display_unit': defaultDisplayUnit,
      if (defaultKerfTicks != null) 'default_kerf_ticks': defaultKerfTicks,
      if (defaultReusableTicks != null)
        'default_reusable_ticks': defaultReusableTicks,
      if (themeMode != null) 'theme_mode': themeMode,
      if (localeTag != null) 'locale_tag': localeTag,
      if (measurementSystem != null) 'measurement_system': measurementSystem,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? defaultDisplayUnit,
    Value<int>? defaultKerfTicks,
    Value<int>? defaultReusableTicks,
    Value<String>? themeMode,
    Value<String?>? localeTag,
    Value<String?>? measurementSystem,
    Value<bool>? onboardingCompleted,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      defaultDisplayUnit: defaultDisplayUnit ?? this.defaultDisplayUnit,
      defaultKerfTicks: defaultKerfTicks ?? this.defaultKerfTicks,
      defaultReusableTicks: defaultReusableTicks ?? this.defaultReusableTicks,
      themeMode: themeMode ?? this.themeMode,
      localeTag: localeTag ?? this.localeTag,
      measurementSystem: measurementSystem ?? this.measurementSystem,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (defaultDisplayUnit.present) {
      map['default_display_unit'] = Variable<String>(defaultDisplayUnit.value);
    }
    if (defaultKerfTicks.present) {
      map['default_kerf_ticks'] = Variable<int>(defaultKerfTicks.value);
    }
    if (defaultReusableTicks.present) {
      map['default_reusable_ticks'] = Variable<int>(defaultReusableTicks.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (localeTag.present) {
      map['locale_tag'] = Variable<String>(localeTag.value);
    }
    if (measurementSystem.present) {
      map['measurement_system'] = Variable<String>(measurementSystem.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('defaultDisplayUnit: $defaultDisplayUnit, ')
          ..write('defaultKerfTicks: $defaultKerfTicks, ')
          ..write('defaultReusableTicks: $defaultReusableTicks, ')
          ..write('themeMode: $themeMode, ')
          ..write('localeTag: $localeTag, ')
          ..write('measurementSystem: $measurementSystem, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }
}

class $EntitlementCacheTable extends EntitlementCache
    with TableInfo<$EntitlementCacheTable, EntitlementCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitlementCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownedMeta = const VerificationMeta('owned');
  @override
  late final GeneratedColumn<bool> owned = GeneratedColumn<bool>(
    'owned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("owned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastVerifiedAtMeta = const VerificationMeta(
    'lastVerifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastVerifiedAt =
      GeneratedColumn<DateTime>(
        'last_verified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [productId, owned, lastVerifiedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entitlement_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntitlementCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('owned')) {
      context.handle(
        _ownedMeta,
        owned.isAcceptableOrUnknown(data['owned']!, _ownedMeta),
      );
    }
    if (data.containsKey('last_verified_at')) {
      context.handle(
        _lastVerifiedAtMeta,
        lastVerifiedAt.isAcceptableOrUnknown(
          data['last_verified_at']!,
          _lastVerifiedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  EntitlementCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitlementCacheData(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      owned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}owned'],
      )!,
      lastVerifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_verified_at'],
      ),
    );
  }

  @override
  $EntitlementCacheTable createAlias(String alias) {
    return $EntitlementCacheTable(attachedDatabase, alias);
  }
}

class EntitlementCacheData extends DataClass
    implements Insertable<EntitlementCacheData> {
  final String productId;
  final bool owned;
  final DateTime? lastVerifiedAt;
  const EntitlementCacheData({
    required this.productId,
    required this.owned,
    this.lastVerifiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['owned'] = Variable<bool>(owned);
    if (!nullToAbsent || lastVerifiedAt != null) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt);
    }
    return map;
  }

  EntitlementCacheCompanion toCompanion(bool nullToAbsent) {
    return EntitlementCacheCompanion(
      productId: Value(productId),
      owned: Value(owned),
      lastVerifiedAt: lastVerifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVerifiedAt),
    );
  }

  factory EntitlementCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitlementCacheData(
      productId: serializer.fromJson<String>(json['productId']),
      owned: serializer.fromJson<bool>(json['owned']),
      lastVerifiedAt: serializer.fromJson<DateTime?>(json['lastVerifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'owned': serializer.toJson<bool>(owned),
      'lastVerifiedAt': serializer.toJson<DateTime?>(lastVerifiedAt),
    };
  }

  EntitlementCacheData copyWith({
    String? productId,
    bool? owned,
    Value<DateTime?> lastVerifiedAt = const Value.absent(),
  }) => EntitlementCacheData(
    productId: productId ?? this.productId,
    owned: owned ?? this.owned,
    lastVerifiedAt: lastVerifiedAt.present
        ? lastVerifiedAt.value
        : this.lastVerifiedAt,
  );
  EntitlementCacheData copyWithCompanion(EntitlementCacheCompanion data) {
    return EntitlementCacheData(
      productId: data.productId.present ? data.productId.value : this.productId,
      owned: data.owned.present ? data.owned.value : this.owned,
      lastVerifiedAt: data.lastVerifiedAt.present
          ? data.lastVerifiedAt.value
          : this.lastVerifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementCacheData(')
          ..write('productId: $productId, ')
          ..write('owned: $owned, ')
          ..write('lastVerifiedAt: $lastVerifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, owned, lastVerifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitlementCacheData &&
          other.productId == this.productId &&
          other.owned == this.owned &&
          other.lastVerifiedAt == this.lastVerifiedAt);
}

class EntitlementCacheCompanion extends UpdateCompanion<EntitlementCacheData> {
  final Value<String> productId;
  final Value<bool> owned;
  final Value<DateTime?> lastVerifiedAt;
  final Value<int> rowid;
  const EntitlementCacheCompanion({
    this.productId = const Value.absent(),
    this.owned = const Value.absent(),
    this.lastVerifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitlementCacheCompanion.insert({
    required String productId,
    this.owned = const Value.absent(),
    this.lastVerifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : productId = Value(productId);
  static Insertable<EntitlementCacheData> custom({
    Expression<String>? productId,
    Expression<bool>? owned,
    Expression<DateTime>? lastVerifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (owned != null) 'owned': owned,
      if (lastVerifiedAt != null) 'last_verified_at': lastVerifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitlementCacheCompanion copyWith({
    Value<String>? productId,
    Value<bool>? owned,
    Value<DateTime?>? lastVerifiedAt,
    Value<int>? rowid,
  }) {
    return EntitlementCacheCompanion(
      productId: productId ?? this.productId,
      owned: owned ?? this.owned,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (owned.present) {
      map['owned'] = Variable<bool>(owned.value);
    }
    if (lastVerifiedAt.present) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementCacheCompanion(')
          ..write('productId: $productId, ')
          ..write('owned: $owned, ')
          ..write('lastVerifiedAt: $lastVerifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $StockLinesTable stockLines = $StockLinesTable(this);
  late final $PartLinesTable partLines = $PartLinesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $EntitlementCacheTable entitlementCache = $EntitlementCacheTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    stockLines,
    partLines,
    appSettings,
    entitlementCache,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stock_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('part_lines', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  Value<String?> material,
  Value<String?> note,
  required String inventoryMode,
  required String displayUnit,
  required int kerfTicks,
  required int endTrimTicks,
  required int minReusableTicks,
  Value<int?> buyStockLengthTicks,
  Value<int> revision,
  Value<String?> lastRunId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> material,
  Value<String?> note,
  Value<String> inventoryMode,
  Value<String> displayUnit,
  Value<int> kerfTicks,
  Value<int> endTrimTicks,
  Value<int> minReusableTicks,
  Value<int?> buyStockLengthTicks,
  Value<int> revision,
  Value<String?> lastRunId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StockLinesTable, List<StockLine>>
  _stockLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockLines,
    aliasName: 'projects__id__stock_lines__project_id',
  );

  $$StockLinesTableProcessedTableManager get stockLinesRefs {
    final manager = $$StockLinesTableTableManager(
      $_db,
      $_db.stockLines,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartLinesTable, List<PartLine>>
  _partLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partLines,
    aliasName: 'projects__id__part_lines__project_id',
  );

  $$PartLinesTableProcessedTableManager get partLinesRefs {
    final manager = $$PartLinesTableTableManager(
      $_db,
      $_db.partLines,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_partLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get material => $composableBuilder(
    column: $table.material,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inventoryMode => $composableBuilder(
    column: $table.inventoryMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayUnit => $composableBuilder(
    column: $table.displayUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kerfTicks => $composableBuilder(
    column: $table.kerfTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endTrimTicks => $composableBuilder(
    column: $table.endTrimTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minReusableTicks => $composableBuilder(
    column: $table.minReusableTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get buyStockLengthTicks => $composableBuilder(
    column: $table.buyStockLengthTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastRunId => $composableBuilder(
    column: $table.lastRunId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> stockLinesRefs(
    Expression<bool> Function($$StockLinesTableFilterComposer f) f,
  ) {
    final $$StockLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockLines,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockLinesTableFilterComposer(
            $db: $db,
            $table: $db.stockLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partLinesRefs(
    Expression<bool> Function($$PartLinesTableFilterComposer f) f,
  ) {
    final $$PartLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partLines,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartLinesTableFilterComposer(
            $db: $db,
            $table: $db.partLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get material => $composableBuilder(
    column: $table.material,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inventoryMode => $composableBuilder(
    column: $table.inventoryMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayUnit => $composableBuilder(
    column: $table.displayUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kerfTicks => $composableBuilder(
    column: $table.kerfTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endTrimTicks => $composableBuilder(
    column: $table.endTrimTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minReusableTicks => $composableBuilder(
    column: $table.minReusableTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get buyStockLengthTicks => $composableBuilder(
    column: $table.buyStockLengthTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastRunId => $composableBuilder(
    column: $table.lastRunId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get material =>
      $composableBuilder(column: $table.material, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get inventoryMode => $composableBuilder(
    column: $table.inventoryMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayUnit => $composableBuilder(
    column: $table.displayUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kerfTicks =>
      $composableBuilder(column: $table.kerfTicks, builder: (column) => column);

  GeneratedColumn<int> get endTrimTicks => $composableBuilder(
    column: $table.endTrimTicks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minReusableTicks => $composableBuilder(
    column: $table.minReusableTicks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get buyStockLengthTicks => $composableBuilder(
    column: $table.buyStockLengthTicks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get lastRunId =>
      $composableBuilder(column: $table.lastRunId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> stockLinesRefs<T extends Object>(
    Expression<T> Function($$StockLinesTableAnnotationComposer a) f,
  ) {
    final $$StockLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockLines,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partLinesRefs<T extends Object>(
    Expression<T> Function($$PartLinesTableAnnotationComposer a) f,
  ) {
    final $$PartLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partLines,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.partLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool stockLinesRefs, bool partLinesRefs})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> material = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> inventoryMode = const Value.absent(),
                Value<String> displayUnit = const Value.absent(),
                Value<int> kerfTicks = const Value.absent(),
                Value<int> endTrimTicks = const Value.absent(),
                Value<int> minReusableTicks = const Value.absent(),
                Value<int?> buyStockLengthTicks = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String?> lastRunId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                material: material,
                note: note,
                inventoryMode: inventoryMode,
                displayUnit: displayUnit,
                kerfTicks: kerfTicks,
                endTrimTicks: endTrimTicks,
                minReusableTicks: minReusableTicks,
                buyStockLengthTicks: buyStockLengthTicks,
                revision: revision,
                lastRunId: lastRunId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> material = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String inventoryMode,
                required String displayUnit,
                required int kerfTicks,
                required int endTrimTicks,
                required int minReusableTicks,
                Value<int?> buyStockLengthTicks = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String?> lastRunId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                material: material,
                note: note,
                inventoryMode: inventoryMode,
                displayUnit: displayUnit,
                kerfTicks: kerfTicks,
                endTrimTicks: endTrimTicks,
                minReusableTicks: minReusableTicks,
                buyStockLengthTicks: buyStockLengthTicks,
                revision: revision,
                lastRunId: lastRunId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, Project>(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({stockLinesRefs = false, partLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockLinesRefs) db.stockLines,
                    if (partLinesRefs) db.partLines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockLinesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          StockLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._stockLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (partLinesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          PartLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._partLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).partLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
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

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool stockLinesRefs, bool partLinesRefs})
    >;
typedef $$StockLinesTableCreateCompanionBuilder = StockLinesCompanion Function({
  required String id,
  required String projectId,
  required int lengthTicks,
  required int quantity,
  Value<String?> label,
  Value<int> sortOrder,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$StockLinesTableUpdateCompanionBuilder = StockLinesCompanion Function({
  Value<String> id,
  Value<String> projectId,
  Value<int> lengthTicks,
  Value<int> quantity,
  Value<String?> label,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$StockLinesTableReferences
    extends BaseReferences<_$AppDatabase, $StockLinesTable, StockLine> {
  $$StockLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('stock_lines__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockLinesTableFilterComposer
    extends Composer<_$AppDatabase, $StockLinesTable> {
  $$StockLinesTableFilterComposer({
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

  ColumnFilters<int> get lengthTicks => $composableBuilder(
    column: $table.lengthTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockLinesTable> {
  $$StockLinesTableOrderingComposer({
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

  ColumnOrderings<int> get lengthTicks => $composableBuilder(
    column: $table.lengthTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockLinesTable> {
  $$StockLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lengthTicks => $composableBuilder(
    column: $table.lengthTicks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockLinesTable,
          StockLine,
          $$StockLinesTableFilterComposer,
          $$StockLinesTableOrderingComposer,
          $$StockLinesTableAnnotationComposer,
          $$StockLinesTableCreateCompanionBuilder,
          $$StockLinesTableUpdateCompanionBuilder,
          (StockLine, $$StockLinesTableReferences),
          StockLine,
          PrefetchHooks Function({bool projectId})
        > {
  $$StockLinesTableTableManager(_$AppDatabase db, $StockLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<int> lengthTicks = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockLinesCompanion(
                id: id,
                projectId: projectId,
                lengthTicks: lengthTicks,
                quantity: quantity,
                label: label,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required int lengthTicks,
                required int quantity,
                Value<String?> label = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StockLinesCompanion.insert(
                id: id,
                projectId: projectId,
                lengthTicks: lengthTicks,
                quantity: quantity,
                label: label,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockLinesTable, StockLine>(table),
                  $$StockLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
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
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$StockLinesTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$StockLinesTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
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

typedef $$StockLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockLinesTable,
      StockLine,
      $$StockLinesTableFilterComposer,
      $$StockLinesTableOrderingComposer,
      $$StockLinesTableAnnotationComposer,
      $$StockLinesTableCreateCompanionBuilder,
      $$StockLinesTableUpdateCompanionBuilder,
      (StockLine, $$StockLinesTableReferences),
      StockLine,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$PartLinesTableCreateCompanionBuilder = PartLinesCompanion Function({
  required String id,
  required String projectId,
  Value<String?> name,
  required int lengthTicks,
  required int quantity,
  Value<int> sortOrder,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PartLinesTableUpdateCompanionBuilder = PartLinesCompanion Function({
  Value<String> id,
  Value<String> projectId,
  Value<String?> name,
  Value<int> lengthTicks,
  Value<int> quantity,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$PartLinesTableReferences
    extends BaseReferences<_$AppDatabase, $PartLinesTable, PartLine> {
  $$PartLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('part_lines__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PartLinesTableFilterComposer
    extends Composer<_$AppDatabase, $PartLinesTable> {
  $$PartLinesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lengthTicks => $composableBuilder(
    column: $table.lengthTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartLinesTable> {
  $$PartLinesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lengthTicks => $composableBuilder(
    column: $table.lengthTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartLinesTable> {
  $$PartLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get lengthTicks => $composableBuilder(
    column: $table.lengthTicks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartLinesTable,
          PartLine,
          $$PartLinesTableFilterComposer,
          $$PartLinesTableOrderingComposer,
          $$PartLinesTableAnnotationComposer,
          $$PartLinesTableCreateCompanionBuilder,
          $$PartLinesTableUpdateCompanionBuilder,
          (PartLine, $$PartLinesTableReferences),
          PartLine,
          PrefetchHooks Function({bool projectId})
        > {
  $$PartLinesTableTableManager(_$AppDatabase db, $PartLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> lengthTicks = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartLinesCompanion(
                id: id,
                projectId: projectId,
                name: name,
                lengthTicks: lengthTicks,
                quantity: quantity,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                Value<String?> name = const Value.absent(),
                required int lengthTicks,
                required int quantity,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PartLinesCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                lengthTicks: lengthTicks,
                quantity: quantity,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PartLinesTable, PartLine>(table),
                  $$PartLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
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
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$PartLinesTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$PartLinesTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
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

typedef $$PartLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartLinesTable,
      PartLine,
      $$PartLinesTableFilterComposer,
      $$PartLinesTableOrderingComposer,
      $$PartLinesTableAnnotationComposer,
      $$PartLinesTableCreateCompanionBuilder,
      $$PartLinesTableUpdateCompanionBuilder,
      (PartLine, $$PartLinesTableReferences),
      PartLine,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      required String defaultDisplayUnit,
      required int defaultKerfTicks,
      required int defaultReusableTicks,
      required String themeMode,
      Value<String?> localeTag,
      Value<String?> measurementSystem,
      Value<bool> onboardingCompleted,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> defaultDisplayUnit,
      Value<int> defaultKerfTicks,
      Value<int> defaultReusableTicks,
      Value<String> themeMode,
      Value<String?> localeTag,
      Value<String?> measurementSystem,
      Value<bool> onboardingCompleted,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultDisplayUnit => $composableBuilder(
    column: $table.defaultDisplayUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultKerfTicks => $composableBuilder(
    column: $table.defaultKerfTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultReusableTicks => $composableBuilder(
    column: $table.defaultReusableTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeTag => $composableBuilder(
    column: $table.localeTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultDisplayUnit => $composableBuilder(
    column: $table.defaultDisplayUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultKerfTicks => $composableBuilder(
    column: $table.defaultKerfTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultReusableTicks => $composableBuilder(
    column: $table.defaultReusableTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeTag => $composableBuilder(
    column: $table.localeTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get defaultDisplayUnit => $composableBuilder(
    column: $table.defaultDisplayUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultKerfTicks => $composableBuilder(
    column: $table.defaultKerfTicks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultReusableTicks => $composableBuilder(
    column: $table.defaultReusableTicks,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get localeTag =>
      $composableBuilder(column: $table.localeTag, builder: (column) => column);

  GeneratedColumn<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> defaultDisplayUnit = const Value.absent(),
                Value<int> defaultKerfTicks = const Value.absent(),
                Value<int> defaultReusableTicks = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> localeTag = const Value.absent(),
                Value<String?> measurementSystem = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                defaultDisplayUnit: defaultDisplayUnit,
                defaultKerfTicks: defaultKerfTicks,
                defaultReusableTicks: defaultReusableTicks,
                themeMode: themeMode,
                localeTag: localeTag,
                measurementSystem: measurementSystem,
                onboardingCompleted: onboardingCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String defaultDisplayUnit,
                required int defaultKerfTicks,
                required int defaultReusableTicks,
                required String themeMode,
                Value<String?> localeTag = const Value.absent(),
                Value<String?> measurementSystem = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                defaultDisplayUnit: defaultDisplayUnit,
                defaultKerfTicks: defaultKerfTicks,
                defaultReusableTicks: defaultReusableTicks,
                themeMode: themeMode,
                localeTag: localeTag,
                measurementSystem: measurementSystem,
                onboardingCompleted: onboardingCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$EntitlementCacheTableCreateCompanionBuilder =
    EntitlementCacheCompanion Function({
      required String productId,
      Value<bool> owned,
      Value<DateTime?> lastVerifiedAt,
      Value<int> rowid,
    });
typedef $$EntitlementCacheTableUpdateCompanionBuilder =
    EntitlementCacheCompanion Function({
      Value<String> productId,
      Value<bool> owned,
      Value<DateTime?> lastVerifiedAt,
      Value<int> rowid,
    });

class $$EntitlementCacheTableFilterComposer
    extends Composer<_$AppDatabase, $EntitlementCacheTable> {
  $$EntitlementCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get owned => $composableBuilder(
    column: $table.owned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntitlementCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitlementCacheTable> {
  $$EntitlementCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get owned => $composableBuilder(
    column: $table.owned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitlementCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitlementCacheTable> {
  $$EntitlementCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<bool> get owned =>
      $composableBuilder(column: $table.owned, builder: (column) => column);

  GeneratedColumn<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => column,
  );
}

class $$EntitlementCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntitlementCacheTable,
          EntitlementCacheData,
          $$EntitlementCacheTableFilterComposer,
          $$EntitlementCacheTableOrderingComposer,
          $$EntitlementCacheTableAnnotationComposer,
          $$EntitlementCacheTableCreateCompanionBuilder,
          $$EntitlementCacheTableUpdateCompanionBuilder,
          (
            EntitlementCacheData,
            BaseReferences<
              _$AppDatabase,
              $EntitlementCacheTable,
              EntitlementCacheData
            >,
          ),
          EntitlementCacheData,
          PrefetchHooks Function()
        > {
  $$EntitlementCacheTableTableManager(
    _$AppDatabase db,
    $EntitlementCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitlementCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitlementCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitlementCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<bool> owned = const Value.absent(),
                Value<DateTime?> lastVerifiedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitlementCacheCompanion(
                productId: productId,
                owned: owned,
                lastVerifiedAt: lastVerifiedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                Value<bool> owned = const Value.absent(),
                Value<DateTime?> lastVerifiedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitlementCacheCompanion.insert(
                productId: productId,
                owned: owned,
                lastVerifiedAt: lastVerifiedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EntitlementCacheTable, EntitlementCacheData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $EntitlementCacheTable,
                    EntitlementCacheData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntitlementCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntitlementCacheTable,
      EntitlementCacheData,
      $$EntitlementCacheTableFilterComposer,
      $$EntitlementCacheTableOrderingComposer,
      $$EntitlementCacheTableAnnotationComposer,
      $$EntitlementCacheTableCreateCompanionBuilder,
      $$EntitlementCacheTableUpdateCompanionBuilder,
      (
        EntitlementCacheData,
        BaseReferences<
          _$AppDatabase,
          $EntitlementCacheTable,
          EntitlementCacheData
        >,
      ),
      EntitlementCacheData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$StockLinesTableTableManager get stockLines =>
      $$StockLinesTableTableManager(_db, _db.stockLines);
  $$PartLinesTableTableManager get partLines =>
      $$PartLinesTableTableManager(_db, _db.partLines);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$EntitlementCacheTableTableManager get entitlementCache =>
      $$EntitlementCacheTableTableManager(_db, _db.entitlementCache);
}
