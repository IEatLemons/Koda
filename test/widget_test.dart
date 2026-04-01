import 'package:flutter_test/flutter_test.dart';

import 'package:obsidian_monitor/data/export/metrics_exporter.dart';

void main() {
  test('CSV export includes metric column headers', () {
    final csv = MetricsExporter.toCsv([]);
    expect(csv, contains('cpu_percent'));
    expect(csv, contains('network_out_bps'));
  });
}
