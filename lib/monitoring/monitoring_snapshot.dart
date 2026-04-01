/// One process row for dashboard "top processes" (point-in-sample, not persisted to DB).
class ProcessSample {
  const ProcessSample({
    required this.name,
    required this.cpuPercent,
    required this.residentBytes,
  });

  final String name;
  final double cpuPercent;
  final int residentBytes;
}

class MonitoringSnapshot {
  const MonitoringSnapshot({
    required this.timestamp,
    required this.cpuPercent,
    required this.memoryUsedBytes,
    required this.memoryTotalBytes,
    required this.diskUsedBytes,
    required this.diskTotalBytes,
    required this.networkInBps,
    required this.networkOutBps,
    this.topProcesses = const [],
  });

  final DateTime timestamp;
  final double cpuPercent;
  final int memoryUsedBytes;
  final int memoryTotalBytes;
  final int diskUsedBytes;
  final int diskTotalBytes;
  final double networkInBps;
  final double networkOutBps;

  /// Top CPU consumers since last sample interval; empty on first tick or if unavailable.
  final List<ProcessSample> topProcesses;

  double get memoryUsedPercent {
    if (memoryTotalBytes <= 0) return 0;
    return 100 * memoryUsedBytes / memoryTotalBytes;
  }

  double get diskUsedPercent {
    if (diskTotalBytes <= 0) return 0;
    return 100 * diskUsedBytes / diskTotalBytes;
  }
}
