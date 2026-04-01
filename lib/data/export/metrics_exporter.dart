import 'dart:convert';

import '../db/app_database.dart';

abstract final class MetricsExporter {
  static String toCsv(List<MetricSampleRow> rows) {
    final b = StringBuffer()
      ..writeln(
        'created_at_iso,cpu_percent,memory_used_bytes,memory_total_bytes,'
        'disk_used_percent,disk_total_bytes,network_in_bps,network_out_bps',
      );
    for (final r in rows) {
      b.writeln([
        r.createdAt.toUtc().toIso8601String(),
        r.cpuPercent.toStringAsFixed(3),
        r.memoryUsedBytes,
        r.memoryTotalBytes,
        r.diskUsedPercent.toStringAsFixed(3),
        r.diskTotalBytes,
        r.networkInBps.toStringAsFixed(3),
        r.networkOutBps.toStringAsFixed(3),
      ].join(','));
    }
    return b.toString();
  }

  static String toJsonLines(List<MetricSampleRow> rows) {
    final b = StringBuffer();
    for (final r in rows) {
      b.writeln(jsonEncode(_rowToMap(r)));
    }
    return b.toString();
  }

  static String toJsonArray(List<MetricSampleRow> rows) {
    final list = rows.map(_rowToMap).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }

  static Map<String, Object?> _rowToMap(MetricSampleRow r) => {
        'created_at': r.createdAt.toUtc().toIso8601String(),
        'cpu_percent': r.cpuPercent,
        'memory_used_bytes': r.memoryUsedBytes,
        'memory_total_bytes': r.memoryTotalBytes,
        'disk_used_percent': r.diskUsedPercent,
        'disk_total_bytes': r.diskTotalBytes,
        'network_in_bps': r.networkInBps,
        'network_out_bps': r.networkOutBps,
      };
}
