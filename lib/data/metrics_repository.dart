import '../monitoring/monitoring_snapshot.dart';
import 'db/app_database.dart';

class MetricsRepository {
  MetricsRepository(this._db);

  final AppDatabase _db;

  Future<int> persist(MonitoringSnapshot s) {
    return _db.insertSample(
      MetricSamplesCompanion.insert(
        createdAt: s.timestamp,
        cpuPercent: s.cpuPercent,
        memoryUsedBytes: s.memoryUsedBytes,
        memoryTotalBytes: s.memoryTotalBytes,
        diskUsedPercent: s.diskUsedPercent,
        diskTotalBytes: s.diskTotalBytes,
        networkInBps: s.networkInBps,
        networkOutBps: s.networkOutBps,
      ),
    );
  }

  Future<List<MetricSampleRow>> samplesBetween(DateTime from, DateTime to) =>
      _db.samplesBetween(from, to);

  Future<void> enforceRetention({required int retentionDays, required int maxSamples}) async {
    final cutoff = DateTime.now().subtract(Duration(days: retentionDays));
    await _db.deleteOlderThan(cutoff);
    await _db.deleteExcessBeyond(maxSamples);
  }

  Future<int> countRows() => _db.countRows();
}
