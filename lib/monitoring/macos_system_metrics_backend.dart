import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'monitoring_backend.dart';
import 'monitoring_snapshot.dart';

/// Reads cumulative interface bytes from native; [networkInBps]/Out computed from deltas here.
class MacosSystemMetricsBackend implements MonitoringBackend {
  MacosSystemMetricsBackend();

  static const MethodChannel _channel = MethodChannel('obsidian_monitor/system_metrics');

  int? _lastInBytes;
  int? _lastOutBytes;
  DateTime? _lastAt;

  @override
  Future<MonitoringSnapshot> read() async {
    if (!Platform.isMacOS) {
      throw UnsupportedError('MacosSystemMetricsBackend only supports macOS');
    }
    try {
      final raw = await _channel.invokeMethod<Map<Object?, Object?>>('getMetrics');
      final map = Map<String, dynamic>.from(raw ?? {});
      final now = DateTime.now();

      final cpu = (map['cpuPercent'] as num?)?.toDouble() ?? 0;
      final memUsed = (map['memoryUsedBytes'] as num?)?.toInt() ?? 0;
      final memTotal = (map['memoryTotalBytes'] as num?)?.toInt() ?? 1;
      final diskUsed = (map['diskUsedBytes'] as num?)?.toInt() ?? 0;
      final diskTotal = (map['diskTotalBytes'] as num?)?.toInt() ?? 1;
      final inBytes = (map['networkInBytes'] as num?)?.toInt() ?? 0;
      final outBytes = (map['networkOutBytes'] as num?)?.toInt() ?? 0;

      double inBps = 0;
      double outBps = 0;
      final prevT = _lastAt;
      final prevIn = _lastInBytes;
      final prevOut = _lastOutBytes;
      if (prevT != null && prevIn != null && prevOut != null) {
        final dt = now.difference(prevT).inMicroseconds / 1e6;
        if (dt > 0) {
          inBps = ((inBytes - prevIn) / dt).clamp(0, double.infinity);
          outBps = ((outBytes - prevOut) / dt).clamp(0, double.infinity);
        }
      }
      _lastAt = now;
      _lastInBytes = inBytes;
      _lastOutBytes = outBytes;

      final topProcesses = _parseTopProcesses(map['topProcesses']);

      return MonitoringSnapshot(
        timestamp: now,
        cpuPercent: cpu,
        memoryUsedBytes: memUsed,
        memoryTotalBytes: memTotal,
        diskUsedBytes: diskUsed,
        diskTotalBytes: diskTotal,
        networkInBps: inBps,
        networkOutBps: outBps,
        topProcesses: topProcesses,
      );
    } on PlatformException catch (e, st) {
      debugPrint('system_metrics channel error: $e\n$st');
      rethrow;
    }
  }

  static List<ProcessSample> _parseTopProcesses(Object? raw) {
    if (raw is! List) return const [];
    final out = <ProcessSample>[];
    for (final e in raw) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final name = m['name'] as String? ?? '';
      final cpu = (m['cpuPercent'] as num?)?.toDouble() ?? 0;
      final mem = (m['memoryBytes'] as num?)?.toInt() ?? 0;
      if (name.isEmpty) continue;
      out.add(ProcessSample(name: name, cpuPercent: cpu, residentBytes: mem));
    }
    return out;
  }
}
