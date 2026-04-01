import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../app/settings_controller.dart';
import '../data/metrics_repository.dart';
import 'fallback_monitoring_backend.dart';
import 'macos_system_metrics_backend.dart';
import 'mock_monitoring_backend.dart';
import 'monitoring_backend.dart';
import 'monitoring_snapshot.dart';

class MonitoringService extends ChangeNotifier {
  MonitoringService({
    required MetricsRepository repository,
    required SettingsController settings,
    MonitoringBackend? backend,
  })  : _repository = repository,
        _settings = settings,
        _backend = backend ?? _defaultBackend() {
    _settings.addListener(_onSettingsChanged);
  }

  final MetricsRepository _repository;
  final SettingsController _settings;
  final MonitoringBackend _backend;

  /// When this service instance was created (approx. app launch).
  final DateTime serviceStartedAt = DateTime.now();

  DateTime? _lastSuccessfulSampleAt;
  DateTime? get lastSuccessfulSampleAt => _lastSuccessfulSampleAt;

  final _latest = StreamController<MonitoringSnapshot>.broadcast();
  Stream<MonitoringSnapshot> get latestStream => _latest.stream;

  MonitoringSnapshot? _current;
  MonitoringSnapshot? get current => _current;

  Timer? _timer;
  bool _running = false;

  static MonitoringBackend _defaultBackend() {
    if (Platform.isMacOS) {
      return FallbackMonitoringBackend(
        primary: MacosSystemMetricsBackend(),
        fallback: MockMonitoringBackend(),
      );
    }
    return MockMonitoringBackend();
  }

  void _onSettingsChanged() {
    if (_running) {
      _restartTimer();
    }
  }

  void start() {
    if (_running) return;
    _running = true;
    _restartTimer();
    unawaited(_tick());
    notifyListeners();
  }

  void stop() {
    _running = false;
    _timer?.cancel();
    _timer = null;
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!_running) return;
    final sec = _settings.sampleIntervalSeconds;
    _timer = Timer.periodic(Duration(seconds: sec), (_) => unawaited(_tick()));
  }

  Future<void> _tick() async {
    if (!_running) return;
    try {
      final snap = await _backend.read();
      _current = snap;
      _latest.add(snap);
      await _repository.persist(snap);
      await _repository.enforceRetention(
        retentionDays: _settings.retentionDays,
        maxSamples: _settings.maxSamples,
      );
      _lastSuccessfulSampleAt = snap.timestamp;
      notifyListeners();
    } catch (e, st) {
      debugPrint('Monitoring tick failed: $e\n$st');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    stop();
    _latest.close();
    super.dispose();
  }
}
