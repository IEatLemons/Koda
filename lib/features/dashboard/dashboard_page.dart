import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/settings_controller.dart';
import '../../data/db/app_database.dart';
import '../../data/metrics_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../monitoring/monitoring_service.dart';
import '../../monitoring/monitoring_snapshot.dart' show MonitoringSnapshot, ProcessSample;
import '../../platform/open_activity_monitor.dart';
import '../../theme/app_colors.dart';
import '../../ui/format_bytes.dart';

const _netGaugeColor = Color(0xFF4A9EFF);

/// Reference-style accent for memory line (not real temperature).
const _memoryLineAccent = Color(0xFFFF6B9D);

const _cardFill = Color(0xFF0E0E12);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<MetricSampleRow> _history = [];

  @override
  void initState() {
    super.initState();
    context.read<MonitoringService>().addListener(_onSvc);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    context.read<MonitoringService>().removeListener(_onSvc);
    super.dispose();
  }

  void _onSvc() => _load();

  Future<void> _load() async {
    final repo = context.read<MetricsRepository>();
    final rows = await repo.samplesBetween(
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now(),
    );
    if (mounted) setState(() => _history = rows);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final svc = context.watch<MonitoringService>();
    final MonitoringSnapshot? s = svc.current;

    return ColoredBox(
      color: AppColors.dashboardCanvas,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
            sliver: SliverToBoxAdapter(
              child: _DashboardHeader(l10n: l10n, settings: settings, snapshot: s),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final cols = w > 1100 ? 4 : (w > 720 ? 2 : 1);
                  const gap = 18.0;
                  if (s == null) {
                    return _DashboardCard(
                      child: SizedBox(
                        height: 160,
                        child: Center(child: Text(l10n.collectingFirstSample)),
                      ),
                    );
                  }
                  final tileW = (w - gap * (cols - 1)) / cols;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      _GaugeTile(
                        width: tileW,
                        title: l10n.tileCpu,
                        subtitle: l10n.tileClusterLoad,
                        percent: s.cpuPercent,
                        color: AppColors.primary,
                        icon: Icons.memory_rounded,
                      ),
                      _GaugeTile(
                        width: tileW,
                        title: l10n.tileRam,
                        subtitle: formatBytes(s.memoryTotalBytes, 0),
                        percent: s.memoryUsedPercent,
                        color: AppColors.secondary,
                        icon: Icons.storage_rounded,
                      ),
                      _GaugeTile(
                        width: tileW,
                        title: l10n.tileDisk,
                        subtitle: formatBytes(s.diskTotalBytes, 0),
                        percent: s.diskUsedPercent,
                        color: AppColors.tertiary,
                        icon: Icons.folder_open_rounded,
                      ),
                      _GaugeTile(
                        width: tileW,
                        title: l10n.tileNetwork,
                        subtitle: formatBps(s.networkInBps + s.networkOutBps, 0),
                        percent: _netPseudoPercent(s),
                        color: _netGaugeColor,
                        icon: Icons.wifi_rounded,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= 920;
                  final chart = _PerformanceChartCard(history: _history, l10n: l10n);
                  final summary = _ProcessSummaryCard(
                    l10n: l10n,
                    historyCount: _history.length,
                    intervalSeconds: settings.sampleIntervalSeconds,
                    uptime: DateTime.now().difference(svc.serviceStartedAt),
                    lastSample: s?.timestamp ?? svc.lastSuccessfulSampleAt,
                    expandVertically: wide,
                  );
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 3, child: chart),
                        const SizedBox(width: 20),
                        SizedBox(width: 300, child: summary),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      chart,
                      const SizedBox(height: 20),
                      summary,
                    ],
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= 800;
                  final table = _ProcessTableCard(
                    l10n: l10n,
                    processes: s?.topProcesses ?? const [],
                    expandBody: wide,
                  );
                  final log = _EventLogCard(
                    l10n: l10n,
                    service: svc,
                    expandFootnote: wide,
                  );
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: table),
                        const SizedBox(width: 16),
                        Expanded(child: log),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      table,
                      const SizedBox(height: 16),
                      log,
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static double _netPseudoPercent(MonitoringSnapshot s) {
    final x = (s.networkInBps + s.networkOutBps) / 125000000;
    return x.clamp(0, 100).toDouble();
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.l10n,
    required this.settings,
    required this.snapshot,
  });

  final AppLocalizations l10n;
  final SettingsController settings;
  final MonitoringSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.liveTelemetryFeed,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (snapshot != null)
                    Text(
                      l10n.updatedAt(_fmtTime(snapshot!.timestamp)),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.6,
                          ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.dashTooltipNotifications,
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
              style: IconButton.styleFrom(foregroundColor: AppColors.onSurfaceVariant),
            ),
            IconButton(
              tooltip: l10n.dashTooltipTelemetry,
              onPressed: () {},
              icon: const Icon(Icons.insights_rounded),
              style: IconButton.styleFrom(foregroundColor: AppColors.onSurfaceVariant),
            ),
            PopupMenuButton<String>(
              tooltip: l10n.dashTooltipLanguage,
              icon: const Icon(Icons.language_rounded),
              onSelected: (v) {
                if (v == 'sys') {
                  settings.setLocaleCode('');
                } else if (v == 'en') {
                  settings.setLocaleCode('en');
                } else {
                  settings.setLocaleCode('zh');
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(value: 'sys', child: Text(l10n.languageSystem)),
                PopupMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                PopupMenuItem(value: 'zh', child: Text(l10n.languageChinese)),
              ],
            ),
            IconButton(
              tooltip: l10n.dashTooltipProfile,
              onPressed: () {},
              icon: const Icon(Icons.person_outline_rounded),
              style: IconButton.styleFrom(foregroundColor: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.35)),
      ],
    );
  }

  static String _fmtTime(DateTime t) {
    final l = TimeOfDay.fromDateTime(t);
    return '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _cardFill,
            Color(0xFF12121A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2E3848).withValues(alpha: 0.75),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GaugeTile extends StatelessWidget {
  const _GaugeTile({
    required this.width,
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.color,
    required this.icon,
  });

  final double width;
  final String title;
  final String subtitle;
  final double percent;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0, 100).toDouble();
    final rest = (100 - p).clamp(0, 100).toDouble();
    return SizedBox(
      width: width,
      child: _DashboardCard(
        child: Row(
          children: [
            SizedBox(
              height: 124,
              width: 124,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: 270,
                      sectionsSpace: 2,
                      centerSpaceRadius: 38,
                      sections: [
                        PieChartSectionData(
                          value: p,
                          color: color,
                          radius: 22,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: rest <= 0 ? 0.001 : rest,
                          color: AppColors.surfaceContainerHighest.withValues(alpha: 0.45),
                          radius: 22,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${p.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          height: 1,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.25,
                                fontWeight: FontWeight.w800,
                                color: color.withValues(alpha: 0.95),
                                fontSize: 11,
                              ),
                        ),
                      ),
                      Icon(icon, size: 22, color: color.withValues(alpha: 0.9)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.35,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.history, required this.l10n});
  final List<MetricSampleRow> history;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) {
      return _DashboardCard(
        child: Text(
          l10n.thermalTrendHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      );
    }
    final n = history.length;
    final spotsCpu = <FlSpot>[];
    final spotsMem = <FlSpot>[];
    for (var i = 0; i < n; i++) {
      final r = history[i];
      spotsCpu.add(FlSpot(i.toDouble(), r.cpuPercent));
      final memPct = r.memoryTotalBytes > 0 ? 100 * r.memoryUsedBytes / r.memoryTotalBytes : 0.0;
      spotsMem.add(FlSpot(i.toDouble(), memPct));
    }

    int labelIndex(double x) => x.round().clamp(0, n - 1);

    bool showLabel(double x) {
      final i = labelIndex(x);
      if (n <= 2) return true;
      final mid = (n - 1) ~/ 2;
      return i == 0 || i == n - 1 || i == mid;
    }

    String bottomTitle(int i) {
      if (i == n - 1) return l10n.dashAxisJustNow;
      final m = history[i].createdAt.difference(history.first.createdAt).inMinutes;
      return l10n.dashAxisMinutesShort(m < 0 ? 0 : m);
    }

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashThermalTitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.dashThermalSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (n - 1).toDouble(),
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: AppColors.outlineVariant.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (v, m) {
                        if (!showLabel(v)) return const SizedBox.shrink();
                        final i = labelIndex(v);
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            bottomTitle(i),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
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
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsCpu,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.45),
                          AppColors.primary.withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: spotsMem,
                    isCurved: true,
                    color: _memoryLineAccent,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendBar(color: AppColors.primary, label: l10n.dashLegendLoadArea),
              const SizedBox(width: 20),
              _LegendDot(color: _memoryLineAccent, label: l10n.dashLegendMemoryLine),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProcessSummaryCard extends StatelessWidget {
  const _ProcessSummaryCard({
    required this.l10n,
    required this.historyCount,
    required this.intervalSeconds,
    required this.uptime,
    required this.lastSample,
    required this.expandVertically,
  });

  final AppLocalizations l10n;
  final int historyCount;
  final int intervalSeconds;
  final Duration uptime;
  final DateTime? lastSample;
  final bool expandVertically;

  @override
  Widget build(BuildContext context) {
    final mac = Platform.isMacOS;
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            l10n.dashProcessSummaryTitle.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.25,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 18),
          _summaryRow(
            context,
            l10n.dashSamplesInWindow,
            '$historyCount',
          ),
          const SizedBox(height: 12),
          _summaryRow(
            context,
            l10n.dashSampleInterval,
            l10n.dashSecondsUnit(intervalSeconds),
          ),
          const SizedBox(height: 12),
          _summaryRow(
            context,
            l10n.dashAppUptime,
            _formatUptimeClock(uptime),
          ),
          const SizedBox(height: 12),
          _summaryRow(
            context,
            l10n.dashLastSample,
            lastSample != null ? _fmtClock(lastSample!) : l10n.dashNoSampleYet,
          ),
          if (expandVertically) const Spacer() else const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: mac ? () => openActivityMonitor() : null,
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(
              l10n.dashOpenActivityMonitor.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.6),
            ),
          ),
          if (!mac) ...[
            const SizedBox(height: 8),
            Text(
              l10n.dashActivityMonitorUnavailable,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            k,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.2,
                ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            v,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
      ],
    );
  }

  /// Reference-style elapsed clock HH:MM:SS.
  static String _formatUptimeClock(Duration d) {
    final th = d.inHours;
    final tm = d.inMinutes.remainder(60);
    final ts = d.inSeconds.remainder(60);
    return '${th.toString().padLeft(2, '0')}:${tm.toString().padLeft(2, '0')}:${ts.toString().padLeft(2, '0')}';
  }

  static String _fmtClock(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
  }
}

String _dashProcessStatusLabel(AppLocalizations l10n, double cpu) {
  if (cpu >= 40) return l10n.dashProcessStatusHigh;
  if (cpu >= 15) return l10n.dashProcessStatusActive;
  if (cpu >= 5) return l10n.dashProcessStatusStable;
  return l10n.dashProcessStatusIdle;
}

(Color, Color) _dashProcessStatusColors(double cpu) {
  if (cpu >= 40) {
    return (AppColors.error.withValues(alpha: 0.12), AppColors.error);
  }
  if (cpu >= 15) {
    return (AppColors.primary.withValues(alpha: 0.14), AppColors.primary);
  }
  return (AppColors.surfaceContainerHighest, AppColors.onSurfaceVariant);
}

Color _dashProcessDotColor(double cpu) {
  if (cpu >= 40) return AppColors.error;
  if (cpu >= 15) return AppColors.primaryContainer;
  if (cpu >= 5) return AppColors.secondary;
  return AppColors.onSurfaceVariant;
}

class _ProcessTableCard extends StatelessWidget {
  const _ProcessTableCard({
    required this.l10n,
    required this.processes,
    required this.expandBody,
  });

  final AppLocalizations l10n;
  final List<ProcessSample> processes;
  final bool expandBody;

  @override
  Widget build(BuildContext context) {
    final dash = l10n.dashProcessNoRows;
    final subtle = TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.7));

    final tableTheme = Theme.of(context).copyWith(
      dividerColor: AppColors.outlineVariant.withValues(alpha: 0.35),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.onSurfaceVariant,
            ),
        dataTextStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );

    List<DataRow> buildRows() {
      if (processes.isEmpty) {
        return [
          DataRow(
            cells: [
              DataCell(Text(dash, style: subtle)),
              DataCell(Text(dash, style: subtle)),
              DataCell(Text(dash, style: subtle)),
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(dash, style: subtle),
                  ],
                ),
              ),
            ],
          ),
        ];
      }
      return processes.map((p) {
        final st = _dashProcessStatusLabel(l10n, p.cpuPercent);
        final (chipBg, chipFg) = _dashProcessStatusColors(p.cpuPercent);
        final dot = _dashProcessDotColor(p.cpuPercent);
        return DataRow(
          cells: [
            DataCell(
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            DataCell(Text('${p.cpuPercent.toStringAsFixed(1)}%')),
            DataCell(Text(formatBytes(p.residentBytes, 1))),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  st,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: chipFg,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                ),
              ),
            ),
          ],
        );
      }).toList();
    }

    Widget table = Theme(
      data: tableTheme,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 52,
          columns: [
            DataColumn(label: Text(l10n.dashProcessColName.toUpperCase())),
            DataColumn(label: Text(l10n.dashProcessColCpu)),
            DataColumn(label: Text(l10n.dashProcessColMemory)),
            DataColumn(label: Text(l10n.dashProcessColStatus.toUpperCase())),
          ],
          rows: buildRows(),
        ),
      ),
    );

    if (expandBody) {
      table = Expanded(
        child: SingleChildScrollView(
          child: table,
        ),
      );
    }

    final footer = Text(
      processes.isNotEmpty ? l10n.dashProcessTableSampleNote : l10n.dashProcessTableEmpty,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
    );

    final bodyChildren = <Widget>[
      Text(
        l10n.dashProcessTableTitle.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.25,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
      ),
      const SizedBox(height: 16),
      table,
      const SizedBox(height: 12),
      footer,
    ];

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: expandBody ? MainAxisSize.max : MainAxisSize.min,
        children: bodyChildren,
      ),
    );
  }
}

class _EventLogCard extends StatelessWidget {
  const _EventLogCard({
    required this.l10n,
    required this.service,
    required this.expandFootnote,
  });

  final AppLocalizations l10n;
  final MonitoringService service;
  final bool expandFootnote;

  @override
  Widget build(BuildContext context) {
    final started = service.serviceStartedAt;
    final last = service.lastSuccessfulSampleAt;
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: expandFootnote ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Text(
            l10n.dashEventLogTitle.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.25,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 18),
          _LogRow(
            color: AppColors.secondary,
            time: _fmtDateTime(started),
            message: l10n.dashLogTelemetryStarted,
          ),
          if (last != null)
            _LogRow(
              color: AppColors.primaryContainer,
              time: _fmtDateTime(last),
              message: l10n.dashLogSampleOk,
            ),
          if (expandFootnote) const Spacer(),
          const SizedBox(height: 8),
          Text(
            l10n.dashEventLogFootnote,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.35,
                ),
          ),
        ],
      ),
    );
  }

  static String _fmtDateTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.color, required this.time, required this.message});

  final Color color;
  final String time;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _LegendBar extends StatelessWidget {
  const _LegendBar({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.25)],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
