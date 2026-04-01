import 'dart:developer';

import 'monitoring_backend.dart';
import 'monitoring_snapshot.dart';

class FallbackMonitoringBackend implements MonitoringBackend {
  FallbackMonitoringBackend({
    required MonitoringBackend primary,
    required MonitoringBackend fallback,
  })  : _primary = primary,
        _fallback = fallback;

  final MonitoringBackend _primary;
  final MonitoringBackend _fallback;
  bool _usingFallback = false;

  @override
  Future<MonitoringSnapshot> read() async {
    try {
      final s = await _primary.read();
      return s;
    } catch (e, st) {
      if (!_usingFallback) {
        _usingFallback = true;
        log('Monitoring primary failed; using mock fallback', error: e, stackTrace: st);
      }
      return _fallback.read();
    }
  }
}
