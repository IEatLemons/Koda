import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('MetricSampleRow')
class MetricSamples extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime()();

  RealColumn get cpuPercent => real()();

  IntColumn get memoryUsedBytes => integer()();

  IntColumn get memoryTotalBytes => integer()();

  RealColumn get diskUsedPercent => real()();

  IntColumn get diskTotalBytes => integer()();

  RealColumn get networkInBps => real()();

  RealColumn get networkOutBps => real()();
}

@DriftDatabase(tables: [MetricSamples])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  static QueryExecutor _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'obsidian_monitor.sqlite'));
      return NativeDatabase(file);
    });
  }

  @override
  int get schemaVersion => 1;

  Future<int> insertSample(MetricSamplesCompanion row) => into(metricSamples).insert(row);

  Future<List<MetricSampleRow>> samplesBetween(DateTime from, DateTime to) {
    return (select(metricSamples)
          ..where((t) => t.createdAt.isBiggerOrEqualValue(from) & t.createdAt.isSmallerOrEqualValue(to))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> deleteOlderThan(DateTime cutoff) async {
    await (delete(metricSamples)..where((t) => t.createdAt.isSmallerThanValue(cutoff))).go();
  }

  Future<int> countRows() async {
    final count = metricSamples.id.count();
    final q = selectOnly(metricSamples)..addColumns([count]);
    final row = await q.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> deleteExcessBeyond(int maxRows) async {
    final total = await countRows();
    if (total <= maxRows) return;
    final toDelete = total - maxRows;
    final old = await (select(metricSamples)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(toDelete))
        .get();
    if (old.isEmpty) return;
    await (delete(metricSamples)..where((t) => t.id.isIn(old.map((e) => e.id)))).go();
  }
}
