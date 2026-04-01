import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../monitoring/monitoring_service.dart';
import '../../monitoring/monitoring_snapshot.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../ui/format_bytes.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = context.watch<MonitoringService>().current;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.processMonitor, style: Theme.of(context).textTheme.labelSmall),
                    Text(l10n.precisionMetrics, style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                const Spacer(),
                if (s != null) ...[
                  _QuickStat(label: l10n.statCpu, value: '${s.cpuPercent.toStringAsFixed(0)}%'),
                  const SizedBox(width: 24),
                  _QuickStat(label: l10n.statMemory, value: '${s.memoryUsedPercent.toStringAsFixed(0)}%'),
                  const SizedBox(width: 24),
                  _QuickStat(label: l10n.statNetworkSum, value: formatBps(s.networkInBps + s.networkOutBps, 0)),
                ],
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(28),
          sliver: SliverToBoxAdapter(
            child: s == null
                ? Text(l10n.waitingTelemetry)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SectionTitle(title: l10n.utilizationOverview, subtitle: l10n.liveSnapshot),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            gridData: const FlGridData(show: true, drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (v, m) {
                                    final labels = [
                                      l10n.chartLabelCpu,
                                      l10n.chartLabelRam,
                                      l10n.chartLabelDisk,
                                      l10n.chartLabelNet,
                                    ];
                                    final i = v.toInt();
                                    if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(labels[i], style: Theme.of(context).textTheme.labelSmall),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (v, m) => Text(
                                    '${v.toInt()}',
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                              ),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              _bar(0, s.cpuPercent, AppColors.primary),
                              _bar(1, s.memoryUsedPercent, AppColors.secondary),
                              _bar(2, s.diskUsedPercent, AppColors.tertiary),
                              _bar(3, _netPseudo(s), AppColors.primaryContainer),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.networkFootnote,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 28),
                      _SectionTitle(title: l10n.memoryAllocation, subtitle: formatBytes(s.memoryTotalBytes, 1)),
                      const SizedBox(height: 12),
                      _MemoryBar(s: s),
                      const SizedBox(height: 28),
                      _SectionTitle(title: l10n.diskThroughput, subtitle: formatBytes(s.diskTotalBytes, 1)),
                      const SizedBox(height: 12),
                      _KeyValueRows(snapshot: s, l10n: l10n),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  static BarChartGroupData _bar(int x, double y, Color c) {
    return BarChartGroupData(
      x: x,
      barRods: [BarChartRodData(toY: y.clamp(0, 100), color: c, width: 18, borderRadius: BorderRadius.circular(4))],
    );
  }

  static double _netPseudo(MonitoringSnapshot s) {
    return ((s.networkInBps + s.networkOutBps) / 125000000 * 100).clamp(0, 100).toDouble();
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 12),
        Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _MemoryBar extends StatelessWidget {
  const _MemoryBar({required this.s});
  final MonitoringSnapshot s;

  @override
  Widget build(BuildContext context) {
    final total = s.memoryTotalBytes <= 0 ? 1 : s.memoryTotalBytes;
    final used = s.memoryUsedBytes.clamp(0, total);
    final free = (total - used).clamp(0, total);
    final uFrac = used / total;
    final fFrac = free / total;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 28,
        child: Row(
          children: [
            Expanded(
              flex: (uFrac * 1000).round().clamp(1, 1000),
              child: ColoredBox(color: AppColors.secondary.withValues(alpha: 0.85), child: const SizedBox.expand()),
            ),
            Expanded(
              flex: (fFrac * 1000).round().clamp(1, 1000),
              child: ColoredBox(color: AppColors.surfaceContainerHighest, child: const SizedBox.expand()),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyValueRows extends StatelessWidget {
  const _KeyValueRows({required this.snapshot, required this.l10n});
  final MonitoringSnapshot snapshot;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (l10n.diskUsed, formatBytes(snapshot.diskUsedBytes.toDouble(), 1)),
      (l10n.diskFree, formatBytes((snapshot.diskTotalBytes - snapshot.diskUsedBytes).toDouble(), 1)),
      (l10n.downlink, formatBps(snapshot.networkInBps)),
      (l10n.uplink, formatBps(snapshot.networkOutBps)),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: Text(e.$1, style: Theme.of(context).textTheme.bodyMedium)),
                Text(e.$2, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
