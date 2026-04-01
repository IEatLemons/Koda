import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../app/settings_controller.dart';
import '../../data/export/metrics_exporter.dart';
import '../../l10n/app_localizations.dart';
import '../../data/metrics_repository.dart';
import '../../monitoring/monitoring_service.dart';
import '../../theme/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsGeneral, style: Theme.of(context).textTheme.labelSmall),
                Text(l10n.preferences, style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: FutureBuilder<String>(
              future: _dbPathHint(),
              builder: (context, snap) {
                final hint = snap.data ?? '…';
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.localDatabase, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      SelectableText(
                        hint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.dbDescription,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(28),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<int>(
                    segments: [
                      ButtonSegment(value: 0, label: Text(l10n.languageSystem)),
                      ButtonSegment(value: 1, label: Text(l10n.languageEnglish)),
                      ButtonSegment(value: 2, label: Text(l10n.languageChinese)),
                    ],
                    selected: {_languageSegment(settings)},
                    onSelectionChanged: (v) async {
                      final n = v.first;
                      if (n == 0) {
                        await settings.setLocaleCode('');
                      } else if (n == 1) {
                        await settings.setLocaleCode('en');
                      } else {
                        await settings.setLocaleCode('zh');
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  Text(l10n.sampling, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(l10n.realTimeSamplingRate, style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 12),
                  SegmentedButton<int>(
                    segments: [
                      ButtonSegment(value: 1, label: Text(l10n.interval1s)),
                      ButtonSegment(value: 5, label: Text(l10n.interval5s)),
                      ButtonSegment(value: 10, label: Text(l10n.interval10s)),
                      ButtonSegment(value: 30, label: Text(l10n.interval30s)),
                    ],
                    selected: {settings.sampleIntervalSeconds},
                    onSelectionChanged: (v) async {
                      final n = v.first;
                      await settings.setSampleIntervalSeconds(n);
                      if (!context.mounted) return;
                      final mon = context.read<MonitoringService>();
                      mon.stop();
                      mon.start();
                    },
                  ),
                  const SizedBox(height: 28),
                  Text(l10n.retention, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.keepSamplesDays, style: Theme.of(context).textTheme.bodyMedium),
                    subtitle: Text(l10n.daysCount(settings.retentionDays), style: Theme.of(context).textTheme.labelSmall),
                    trailing: SizedBox(
                      width: 200,
                      child: Slider(
                        value: settings.retentionDays.toDouble(),
                        min: 1,
                        max: 90,
                        divisions: 89,
                        label: l10n.sliderDaysLabel(settings.retentionDays),
                        onChanged: (x) => settings.setRetentionDays(x.round()),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.maxRowsTrim, style: Theme.of(context).textTheme.bodyMedium),
                    subtitle: Text('${settings.maxSamples}', style: Theme.of(context).textTheme.labelSmall),
                    trailing: SizedBox(
                      width: 200,
                      child: Slider(
                        value: settings.maxSamples.clamp(5000, 500000).toDouble(),
                        min: 5000,
                        max: 500000,
                        divisions: 99,
                        label: '${settings.maxSamples}',
                        onChanged: (x) => settings.setMaxSamples(x.round()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
          sliver: SliverToBoxAdapter(
            child: OutlinedButton.icon(
              onPressed: () => _exportFull(context),
              icon: const Icon(Icons.save_alt_rounded, size: 18),
              label: Text(l10n.exportAllCsv),
            ),
          ),
        ),
      ],
    );
  }

  static int _languageSegment(SettingsController settings) {
    if (settings.localeCode.isEmpty) return 0;
    if (settings.localeCode == 'en') return 1;
    return 2;
  }

  static Future<String> _dbPathHint() async {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, 'obsidian_monitor.sqlite');
  }

  static Future<void> _exportFull(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final repo = context.read<MetricsRepository>();
    final rows = await repo.samplesBetween(
      DateTime.fromMillisecondsSinceEpoch(0),
      DateTime.now().add(const Duration(days: 1)),
    );
    final loc = await getSaveLocation(
      suggestedName: 'obsidian_metrics_full.csv',
      acceptedTypeGroups: [XTypeGroup(label: l10n.fileTypeCsv, extensions: ['csv'])],
    );
    if (loc == null) return;
    final csv = MetricsExporter.toCsv(rows);
    await File(loc.path).writeAsString(csv);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.savedPathRows(loc.path, rows.length))));
    }
  }
}
