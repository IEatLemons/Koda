import 'dart:math';

import 'monitoring_backend.dart';
import 'monitoring_snapshot.dart';

class MockMonitoringBackend implements MonitoringBackend {
  MockMonitoringBackend() : _rand = Random();

  final Random _rand;

  @override
  Future<MonitoringSnapshot> read() async {
    final base = DateTime.now().millisecondsSinceEpoch / 5000;
    final cpu = (48 + 22 * sin(base)).clamp(5, 95).toDouble();
    final memTotal = 16 * 1024 * 1024 * 1024;
    final memUsed = (memTotal * (0.35 + 0.15 * sin(base * 1.3))).round();
    final diskTotal = 1000 * 1000 * 1000 * 1000;
    final diskUsed = (diskTotal * (0.55 + 0.1 * cos(base * 0.7))).round();
    return MonitoringSnapshot(
      timestamp: DateTime.now(),
      cpuPercent: cpu,
      memoryUsedBytes: memUsed,
      memoryTotalBytes: memTotal,
      diskUsedBytes: diskUsed,
      diskTotalBytes: diskTotal,
      networkInBps: 50_000 + _rand.nextDouble() * 200_000,
      networkOutBps: 20_000 + _rand.nextDouble() * 80_000,
      topProcesses: [
        ProcessSample(
          name: 'WindowServer',
          cpuPercent: 8 + _rand.nextDouble() * 12,
          residentBytes: 380 * 1024 * 1024,
        ),
        ProcessSample(
          name: 'obsidian_monitor',
          cpuPercent: 3 + _rand.nextDouble() * 8,
          residentBytes: 120 * 1024 * 1024,
        ),
        ProcessSample(
          name: 'kernel_task',
          cpuPercent: 2 + _rand.nextDouble() * 6,
          residentBytes: 40 * 1024 * 1024,
        ),
        ProcessSample(
          name: 'Docker Desktop',
          cpuPercent: 1 + _rand.nextDouble() * 5,
          residentBytes: 2 * 1024 * 1024 * 1024,
        ),
      ],
    );
  }
}
