import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/export/metrics_exporter.dart';
import '../../data/metrics_repository.dart';
import '../../data/db/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

enum HistoryWindow { h1, h6, h24, d7 }

extension on HistoryWindow {
  Duration get duration => switch (this) {
        HistoryWindow.h1 => const Duration(hours: 1),
        HistoryWindow.h6 => const Duration(hours: 6),
        HistoryWindow.h24 => const Duration(hours: 24),
        HistoryWindow.d7 => const Duration(days: 7),
      };

  String windowLabel(AppLocalizations l10n) => switch (this) {
        HistoryWindow.h1 => l10n.historyWindowH1,
        HistoryWindow.h6 => l10n.historyWindowH6,
        HistoryWindow.h24 => l10n.historyWindowH24,
        HistoryWindow.d7 => l10n.historyWindowD7,
      };
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryWindow _window = HistoryWindow.h24;
  List<MetricSampleRow> _rows = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = context.read<MetricsRepository>();
    final to = DateTime.now();
    final from = to.subtract(_window.duration);
    final rows = await repo.samplesBetween(from, to);
    if (mounted) {
      setState(() {
        _rows = rows;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
          sliver: SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const breakpoint = 720.0;
                final narrow = constraints.maxWidth < breakpoint;

                Widget titleColumn() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.historicalTrends,
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.lastWindow(_window.windowLabel(l10n)),
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );

                Widget toolbar() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: narrow ? WrapAlignment.start : WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SegmentedButton<HistoryWindow>(
                          segments: HistoryWindow.values
                              .map(
                                (w) => ButtonSegment<HistoryWindow>(
                                  value: w,
                                  label: Text(w.windowLabel(l10n)),
                                ),
                              )
                              .toList(),
                          selected: {_window},
                          onSelectionChanged: (s) {
                            setState(() => _window = s.first);
                            _load();
                          },
                        ),
                        FilledButton.icon(
                          onPressed: _loading ? null : _exportCsv,
                          icon: const Icon(Icons.save_alt_rounded, size: 18),
                          label: Text(l10n.exportCsv),
                        ),
                        OutlinedButton(
                          onPressed: _loading ? null : _exportJson,
                          child: Text(l10n.exportJson),
                        ),
                      ],
                    );

                if (narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      titleColumn(),
                      const SizedBox(height: 12),
                      toolbar(),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: titleColumn()),
                    const SizedBox(width: 16),
                    Flexible(child: toolbar()),
                  ],
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(28),
          sliver: SliverToBoxAdapter(
            child: _loading
                ? const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()))
                : _rows.length < 2
                    ? Text(
                        l10n.noSamplesInWindow,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : _HistoryCharts(rows: _rows),
          ),
        ),
      ],
    );
  }

  List<MetricSampleRow> get _exportRows => _rows;

  Future<void> _exportCsv() async {
    final l10n = AppLocalizations.of(context)!;
    final loc = await getSaveLocation(
      suggestedName: 'obsidian_metrics.csv',
      acceptedTypeGroups: [XTypeGroup(label: l10n.fileTypeCsv, extensions: ['csv'])],
    );
    if (loc == null) return;
    final csv = MetricsExporter.toCsv(_exportRows);
    await File(loc.path).writeAsString(csv);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.savedPath(loc.path))));
    }
  }

  Future<void> _exportJson() async {
    final l10n = AppLocalizations.of(context)!;
    final loc = await getSaveLocation(
      suggestedName: 'obsidian_metrics.json',
      acceptedTypeGroups: [XTypeGroup(label: l10n.fileTypeJson, extensions: ['json'])],
    );
    if (loc == null) return;
    final j = MetricsExporter.toJsonArray(_exportRows);
    await File(loc.path).writeAsString(j);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.savedPath(loc.path))));
    }
  }
}

class _HistoryCharts extends StatelessWidget {
  const _HistoryCharts({required this.rows});
  final List<MetricSampleRow> rows;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final spotsCpu = <FlSpot>[];
    final spotsMem = <FlSpot>[];
    for (var i = 0; i < rows.length; i++) {
      final r = rows[i];
      final t = r.createdAt.millisecondsSinceEpoch.toDouble();
      spotsCpu.add(FlSpot(t, r.cpuPercent));
      spotsMem.add(
        FlSpot(
          t,
          r.memoryTotalBytes > 0 ? 100 * r.memoryUsedBytes / r.memoryTotalBytes : 0,
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.chartCpuMemory, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, m) => Text(
                        _labelForEpoch(v),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (v, m) => Text('${v.toInt()}', style: Theme.of(context).textTheme.labelSmall),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsCpu,
                    isCurved: false,
                    color: AppColors.primary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: spotsMem,
                    isCurved: false,
                    color: AppColors.secondary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.samplesCount(rows.length), style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  static String _labelForEpoch(double ms) {
    if (ms == 0) return '';
    final t = DateTime.fromMillisecondsSinceEpoch(ms.round());
    return '${t.hour}:${t.minute.toString().padLeft(2, '0')}';
  }
}
