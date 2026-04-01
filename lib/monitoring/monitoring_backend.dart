import 'monitoring_snapshot.dart';

abstract interface class MonitoringBackend {
  Future<MonitoringSnapshot> read();
}
