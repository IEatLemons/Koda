// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MetricSamplesTable extends MetricSamples
    with TableInfo<$MetricSamplesTable, MetricSampleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _cpuPercentMeta = const VerificationMeta(
    'cpuPercent',
  );
  @override
  late final GeneratedColumn<double> cpuPercent = GeneratedColumn<double>(
    'cpu_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoryUsedBytesMeta = const VerificationMeta(
    'memoryUsedBytes',
  );
  @override
  late final GeneratedColumn<int> memoryUsedBytes = GeneratedColumn<int>(
    'memory_used_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoryTotalBytesMeta = const VerificationMeta(
    'memoryTotalBytes',
  );
  @override
  late final GeneratedColumn<int> memoryTotalBytes = GeneratedColumn<int>(
    'memory_total_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diskUsedPercentMeta = const VerificationMeta(
    'diskUsedPercent',
  );
  @override
  late final GeneratedColumn<double> diskUsedPercent = GeneratedColumn<double>(
    'disk_used_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diskTotalBytesMeta = const VerificationMeta(
    'diskTotalBytes',
  );
  @override
  late final GeneratedColumn<int> diskTotalBytes = GeneratedColumn<int>(
    'disk_total_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkInBpsMeta = const VerificationMeta(
    'networkInBps',
  );
  @override
  late final GeneratedColumn<double> networkInBps = GeneratedColumn<double>(
    'network_in_bps',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkOutBpsMeta = const VerificationMeta(
    'networkOutBps',
  );
  @override
  late final GeneratedColumn<double> networkOutBps = GeneratedColumn<double>(
    'network_out_bps',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    cpuPercent,
    memoryUsedBytes,
    memoryTotalBytes,
    diskUsedPercent,
    diskTotalBytes,
    networkInBps,
    networkOutBps,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metric_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetricSampleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('cpu_percent')) {
      context.handle(
        _cpuPercentMeta,
        cpuPercent.isAcceptableOrUnknown(data['cpu_percent']!, _cpuPercentMeta),
      );
    } else if (isInserting) {
      context.missing(_cpuPercentMeta);
    }
    if (data.containsKey('memory_used_bytes')) {
      context.handle(
        _memoryUsedBytesMeta,
        memoryUsedBytes.isAcceptableOrUnknown(
          data['memory_used_bytes']!,
          _memoryUsedBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_memoryUsedBytesMeta);
    }
    if (data.containsKey('memory_total_bytes')) {
      context.handle(
        _memoryTotalBytesMeta,
        memoryTotalBytes.isAcceptableOrUnknown(
          data['memory_total_bytes']!,
          _memoryTotalBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_memoryTotalBytesMeta);
    }
    if (data.containsKey('disk_used_percent')) {
      context.handle(
        _diskUsedPercentMeta,
        diskUsedPercent.isAcceptableOrUnknown(
          data['disk_used_percent']!,
          _diskUsedPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diskUsedPercentMeta);
    }
    if (data.containsKey('disk_total_bytes')) {
      context.handle(
        _diskTotalBytesMeta,
        diskTotalBytes.isAcceptableOrUnknown(
          data['disk_total_bytes']!,
          _diskTotalBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diskTotalBytesMeta);
    }
    if (data.containsKey('network_in_bps')) {
      context.handle(
        _networkInBpsMeta,
        networkInBps.isAcceptableOrUnknown(
          data['network_in_bps']!,
          _networkInBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_networkInBpsMeta);
    }
    if (data.containsKey('network_out_bps')) {
      context.handle(
        _networkOutBpsMeta,
        networkOutBps.isAcceptableOrUnknown(
          data['network_out_bps']!,
          _networkOutBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_networkOutBpsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MetricSampleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetricSampleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      cpuPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cpu_percent'],
      )!,
      memoryUsedBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}memory_used_bytes'],
      )!,
      memoryTotalBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}memory_total_bytes'],
      )!,
      diskUsedPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}disk_used_percent'],
      )!,
      diskTotalBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disk_total_bytes'],
      )!,
      networkInBps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}network_in_bps'],
      )!,
      networkOutBps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}network_out_bps'],
      )!,
    );
  }

  @override
  $MetricSamplesTable createAlias(String alias) {
    return $MetricSamplesTable(attachedDatabase, alias);
  }
}

class MetricSampleRow extends DataClass implements Insertable<MetricSampleRow> {
  final int id;
  final DateTime createdAt;
  final double cpuPercent;
  final int memoryUsedBytes;
  final int memoryTotalBytes;
  final double diskUsedPercent;
  final int diskTotalBytes;
  final double networkInBps;
  final double networkOutBps;
  const MetricSampleRow({
    required this.id,
    required this.createdAt,
    required this.cpuPercent,
    required this.memoryUsedBytes,
    required this.memoryTotalBytes,
    required this.diskUsedPercent,
    required this.diskTotalBytes,
    required this.networkInBps,
    required this.networkOutBps,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cpu_percent'] = Variable<double>(cpuPercent);
    map['memory_used_bytes'] = Variable<int>(memoryUsedBytes);
    map['memory_total_bytes'] = Variable<int>(memoryTotalBytes);
    map['disk_used_percent'] = Variable<double>(diskUsedPercent);
    map['disk_total_bytes'] = Variable<int>(diskTotalBytes);
    map['network_in_bps'] = Variable<double>(networkInBps);
    map['network_out_bps'] = Variable<double>(networkOutBps);
    return map;
  }

  MetricSamplesCompanion toCompanion(bool nullToAbsent) {
    return MetricSamplesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      cpuPercent: Value(cpuPercent),
      memoryUsedBytes: Value(memoryUsedBytes),
      memoryTotalBytes: Value(memoryTotalBytes),
      diskUsedPercent: Value(diskUsedPercent),
      diskTotalBytes: Value(diskTotalBytes),
      networkInBps: Value(networkInBps),
      networkOutBps: Value(networkOutBps),
    );
  }

  factory MetricSampleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetricSampleRow(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cpuPercent: serializer.fromJson<double>(json['cpuPercent']),
      memoryUsedBytes: serializer.fromJson<int>(json['memoryUsedBytes']),
      memoryTotalBytes: serializer.fromJson<int>(json['memoryTotalBytes']),
      diskUsedPercent: serializer.fromJson<double>(json['diskUsedPercent']),
      diskTotalBytes: serializer.fromJson<int>(json['diskTotalBytes']),
      networkInBps: serializer.fromJson<double>(json['networkInBps']),
      networkOutBps: serializer.fromJson<double>(json['networkOutBps']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cpuPercent': serializer.toJson<double>(cpuPercent),
      'memoryUsedBytes': serializer.toJson<int>(memoryUsedBytes),
      'memoryTotalBytes': serializer.toJson<int>(memoryTotalBytes),
      'diskUsedPercent': serializer.toJson<double>(diskUsedPercent),
      'diskTotalBytes': serializer.toJson<int>(diskTotalBytes),
      'networkInBps': serializer.toJson<double>(networkInBps),
      'networkOutBps': serializer.toJson<double>(networkOutBps),
    };
  }

  MetricSampleRow copyWith({
    int? id,
    DateTime? createdAt,
    double? cpuPercent,
    int? memoryUsedBytes,
    int? memoryTotalBytes,
    double? diskUsedPercent,
    int? diskTotalBytes,
    double? networkInBps,
    double? networkOutBps,
  }) => MetricSampleRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    cpuPercent: cpuPercent ?? this.cpuPercent,
    memoryUsedBytes: memoryUsedBytes ?? this.memoryUsedBytes,
    memoryTotalBytes: memoryTotalBytes ?? this.memoryTotalBytes,
    diskUsedPercent: diskUsedPercent ?? this.diskUsedPercent,
    diskTotalBytes: diskTotalBytes ?? this.diskTotalBytes,
    networkInBps: networkInBps ?? this.networkInBps,
    networkOutBps: networkOutBps ?? this.networkOutBps,
  );
  MetricSampleRow copyWithCompanion(MetricSamplesCompanion data) {
    return MetricSampleRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cpuPercent: data.cpuPercent.present
          ? data.cpuPercent.value
          : this.cpuPercent,
      memoryUsedBytes: data.memoryUsedBytes.present
          ? data.memoryUsedBytes.value
          : this.memoryUsedBytes,
      memoryTotalBytes: data.memoryTotalBytes.present
          ? data.memoryTotalBytes.value
          : this.memoryTotalBytes,
      diskUsedPercent: data.diskUsedPercent.present
          ? data.diskUsedPercent.value
          : this.diskUsedPercent,
      diskTotalBytes: data.diskTotalBytes.present
          ? data.diskTotalBytes.value
          : this.diskTotalBytes,
      networkInBps: data.networkInBps.present
          ? data.networkInBps.value
          : this.networkInBps,
      networkOutBps: data.networkOutBps.present
          ? data.networkOutBps.value
          : this.networkOutBps,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetricSampleRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('cpuPercent: $cpuPercent, ')
          ..write('memoryUsedBytes: $memoryUsedBytes, ')
          ..write('memoryTotalBytes: $memoryTotalBytes, ')
          ..write('diskUsedPercent: $diskUsedPercent, ')
          ..write('diskTotalBytes: $diskTotalBytes, ')
          ..write('networkInBps: $networkInBps, ')
          ..write('networkOutBps: $networkOutBps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    cpuPercent,
    memoryUsedBytes,
    memoryTotalBytes,
    diskUsedPercent,
    diskTotalBytes,
    networkInBps,
    networkOutBps,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetricSampleRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.cpuPercent == this.cpuPercent &&
          other.memoryUsedBytes == this.memoryUsedBytes &&
          other.memoryTotalBytes == this.memoryTotalBytes &&
          other.diskUsedPercent == this.diskUsedPercent &&
          other.diskTotalBytes == this.diskTotalBytes &&
          other.networkInBps == this.networkInBps &&
          other.networkOutBps == this.networkOutBps);
}

class MetricSamplesCompanion extends UpdateCompanion<MetricSampleRow> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<double> cpuPercent;
  final Value<int> memoryUsedBytes;
  final Value<int> memoryTotalBytes;
  final Value<double> diskUsedPercent;
  final Value<int> diskTotalBytes;
  final Value<double> networkInBps;
  final Value<double> networkOutBps;
  const MetricSamplesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cpuPercent = const Value.absent(),
    this.memoryUsedBytes = const Value.absent(),
    this.memoryTotalBytes = const Value.absent(),
    this.diskUsedPercent = const Value.absent(),
    this.diskTotalBytes = const Value.absent(),
    this.networkInBps = const Value.absent(),
    this.networkOutBps = const Value.absent(),
  });
  MetricSamplesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required double cpuPercent,
    required int memoryUsedBytes,
    required int memoryTotalBytes,
    required double diskUsedPercent,
    required int diskTotalBytes,
    required double networkInBps,
    required double networkOutBps,
  }) : createdAt = Value(createdAt),
       cpuPercent = Value(cpuPercent),
       memoryUsedBytes = Value(memoryUsedBytes),
       memoryTotalBytes = Value(memoryTotalBytes),
       diskUsedPercent = Value(diskUsedPercent),
       diskTotalBytes = Value(diskTotalBytes),
       networkInBps = Value(networkInBps),
       networkOutBps = Value(networkOutBps);
  static Insertable<MetricSampleRow> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<double>? cpuPercent,
    Expression<int>? memoryUsedBytes,
    Expression<int>? memoryTotalBytes,
    Expression<double>? diskUsedPercent,
    Expression<int>? diskTotalBytes,
    Expression<double>? networkInBps,
    Expression<double>? networkOutBps,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (cpuPercent != null) 'cpu_percent': cpuPercent,
      if (memoryUsedBytes != null) 'memory_used_bytes': memoryUsedBytes,
      if (memoryTotalBytes != null) 'memory_total_bytes': memoryTotalBytes,
      if (diskUsedPercent != null) 'disk_used_percent': diskUsedPercent,
      if (diskTotalBytes != null) 'disk_total_bytes': diskTotalBytes,
      if (networkInBps != null) 'network_in_bps': networkInBps,
      if (networkOutBps != null) 'network_out_bps': networkOutBps,
    });
  }

  MetricSamplesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<double>? cpuPercent,
    Value<int>? memoryUsedBytes,
    Value<int>? memoryTotalBytes,
    Value<double>? diskUsedPercent,
    Value<int>? diskTotalBytes,
    Value<double>? networkInBps,
    Value<double>? networkOutBps,
  }) {
    return MetricSamplesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      cpuPercent: cpuPercent ?? this.cpuPercent,
      memoryUsedBytes: memoryUsedBytes ?? this.memoryUsedBytes,
      memoryTotalBytes: memoryTotalBytes ?? this.memoryTotalBytes,
      diskUsedPercent: diskUsedPercent ?? this.diskUsedPercent,
      diskTotalBytes: diskTotalBytes ?? this.diskTotalBytes,
      networkInBps: networkInBps ?? this.networkInBps,
      networkOutBps: networkOutBps ?? this.networkOutBps,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cpuPercent.present) {
      map['cpu_percent'] = Variable<double>(cpuPercent.value);
    }
    if (memoryUsedBytes.present) {
      map['memory_used_bytes'] = Variable<int>(memoryUsedBytes.value);
    }
    if (memoryTotalBytes.present) {
      map['memory_total_bytes'] = Variable<int>(memoryTotalBytes.value);
    }
    if (diskUsedPercent.present) {
      map['disk_used_percent'] = Variable<double>(diskUsedPercent.value);
    }
    if (diskTotalBytes.present) {
      map['disk_total_bytes'] = Variable<int>(diskTotalBytes.value);
    }
    if (networkInBps.present) {
      map['network_in_bps'] = Variable<double>(networkInBps.value);
    }
    if (networkOutBps.present) {
      map['network_out_bps'] = Variable<double>(networkOutBps.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricSamplesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('cpuPercent: $cpuPercent, ')
          ..write('memoryUsedBytes: $memoryUsedBytes, ')
          ..write('memoryTotalBytes: $memoryTotalBytes, ')
          ..write('diskUsedPercent: $diskUsedPercent, ')
          ..write('diskTotalBytes: $diskTotalBytes, ')
          ..write('networkInBps: $networkInBps, ')
          ..write('networkOutBps: $networkOutBps')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MetricSamplesTable metricSamples = $MetricSamplesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [metricSamples];
}

typedef $$MetricSamplesTableCreateCompanionBuilder =
    MetricSamplesCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      required double cpuPercent,
      required int memoryUsedBytes,
      required int memoryTotalBytes,
      required double diskUsedPercent,
      required int diskTotalBytes,
      required double networkInBps,
      required double networkOutBps,
    });
typedef $$MetricSamplesTableUpdateCompanionBuilder =
    MetricSamplesCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<double> cpuPercent,
      Value<int> memoryUsedBytes,
      Value<int> memoryTotalBytes,
      Value<double> diskUsedPercent,
      Value<int> diskTotalBytes,
      Value<double> networkInBps,
      Value<double> networkOutBps,
    });

class $$MetricSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $MetricSamplesTable> {
  $$MetricSamplesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cpuPercent => $composableBuilder(
    column: $table.cpuPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memoryUsedBytes => $composableBuilder(
    column: $table.memoryUsedBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memoryTotalBytes => $composableBuilder(
    column: $table.memoryTotalBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diskUsedPercent => $composableBuilder(
    column: $table.diskUsedPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskTotalBytes => $composableBuilder(
    column: $table.diskTotalBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get networkInBps => $composableBuilder(
    column: $table.networkInBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get networkOutBps => $composableBuilder(
    column: $table.networkOutBps,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetricSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $MetricSamplesTable> {
  $$MetricSamplesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cpuPercent => $composableBuilder(
    column: $table.cpuPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memoryUsedBytes => $composableBuilder(
    column: $table.memoryUsedBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memoryTotalBytes => $composableBuilder(
    column: $table.memoryTotalBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diskUsedPercent => $composableBuilder(
    column: $table.diskUsedPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskTotalBytes => $composableBuilder(
    column: $table.diskTotalBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get networkInBps => $composableBuilder(
    column: $table.networkInBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get networkOutBps => $composableBuilder(
    column: $table.networkOutBps,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetricSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetricSamplesTable> {
  $$MetricSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get cpuPercent => $composableBuilder(
    column: $table.cpuPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get memoryUsedBytes => $composableBuilder(
    column: $table.memoryUsedBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get memoryTotalBytes => $composableBuilder(
    column: $table.memoryTotalBytes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get diskUsedPercent => $composableBuilder(
    column: $table.diskUsedPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diskTotalBytes => $composableBuilder(
    column: $table.diskTotalBytes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get networkInBps => $composableBuilder(
    column: $table.networkInBps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get networkOutBps => $composableBuilder(
    column: $table.networkOutBps,
    builder: (column) => column,
  );
}

class $$MetricSamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetricSamplesTable,
          MetricSampleRow,
          $$MetricSamplesTableFilterComposer,
          $$MetricSamplesTableOrderingComposer,
          $$MetricSamplesTableAnnotationComposer,
          $$MetricSamplesTableCreateCompanionBuilder,
          $$MetricSamplesTableUpdateCompanionBuilder,
          (
            MetricSampleRow,
            BaseReferences<_$AppDatabase, $MetricSamplesTable, MetricSampleRow>,
          ),
          MetricSampleRow,
          PrefetchHooks Function()
        > {
  $$MetricSamplesTableTableManager(_$AppDatabase db, $MetricSamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetricSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetricSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetricSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double> cpuPercent = const Value.absent(),
                Value<int> memoryUsedBytes = const Value.absent(),
                Value<int> memoryTotalBytes = const Value.absent(),
                Value<double> diskUsedPercent = const Value.absent(),
                Value<int> diskTotalBytes = const Value.absent(),
                Value<double> networkInBps = const Value.absent(),
                Value<double> networkOutBps = const Value.absent(),
              }) => MetricSamplesCompanion(
                id: id,
                createdAt: createdAt,
                cpuPercent: cpuPercent,
                memoryUsedBytes: memoryUsedBytes,
                memoryTotalBytes: memoryTotalBytes,
                diskUsedPercent: diskUsedPercent,
                diskTotalBytes: diskTotalBytes,
                networkInBps: networkInBps,
                networkOutBps: networkOutBps,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                required double cpuPercent,
                required int memoryUsedBytes,
                required int memoryTotalBytes,
                required double diskUsedPercent,
                required int diskTotalBytes,
                required double networkInBps,
                required double networkOutBps,
              }) => MetricSamplesCompanion.insert(
                id: id,
                createdAt: createdAt,
                cpuPercent: cpuPercent,
                memoryUsedBytes: memoryUsedBytes,
                memoryTotalBytes: memoryTotalBytes,
                diskUsedPercent: diskUsedPercent,
                diskTotalBytes: diskTotalBytes,
                networkInBps: networkInBps,
                networkOutBps: networkOutBps,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetricSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetricSamplesTable,
      MetricSampleRow,
      $$MetricSamplesTableFilterComposer,
      $$MetricSamplesTableOrderingComposer,
      $$MetricSamplesTableAnnotationComposer,
      $$MetricSamplesTableCreateCompanionBuilder,
      $$MetricSamplesTableUpdateCompanionBuilder,
      (
        MetricSampleRow,
        BaseReferences<_$AppDatabase, $MetricSamplesTable, MetricSampleRow>,
      ),
      MetricSampleRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MetricSamplesTableTableManager get metricSamples =>
      $$MetricSamplesTableTableManager(_db, _db.metricSamples);
}
