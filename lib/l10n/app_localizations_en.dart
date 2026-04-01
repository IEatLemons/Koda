// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Obsidian Monitor';

  @override
  String get appSubtitle => 'V1.0.4 · Precision Instrument';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navMetrics => 'Metrics';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get userAdmin => 'Admin';

  @override
  String get userRootAccess => 'Root access';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String updatedAt(String time) {
    return 'Updated $time';
  }

  @override
  String get collectingFirstSample => 'Collecting first sample…';

  @override
  String get tileCpu => 'CPU';

  @override
  String get tileClusterLoad => 'Cluster load';

  @override
  String get tileRam => 'RAM';

  @override
  String get tileDisk => 'Disk';

  @override
  String get tileNetwork => 'Network';

  @override
  String get thermalTrendHint =>
      'Thermal / load trend appears after more samples are stored.';

  @override
  String get loadMemoryLastHour => 'Load & memory (last hour)';

  @override
  String get legendCpuPct => 'CPU %';

  @override
  String get legendMemoryPct => 'Memory %';

  @override
  String get processMonitor => 'PROCESS MONITOR';

  @override
  String get precisionMetrics => 'Precision Metrics';

  @override
  String get statCpu => 'CPU';

  @override
  String get statMemory => 'Memory';

  @override
  String get statNetworkSum => 'Network ∑';

  @override
  String get waitingTelemetry => 'Waiting for telemetry…';

  @override
  String get utilizationOverview => 'Utilization overview';

  @override
  String get liveSnapshot => 'Live snapshot';

  @override
  String get chartLabelCpu => 'CPU';

  @override
  String get chartLabelRam => 'RAM';

  @override
  String get chartLabelDisk => 'Disk';

  @override
  String get chartLabelNet => 'Net*';

  @override
  String get networkFootnote =>
      '* Network ring is scaled heuristically vs 1 Gbps.';

  @override
  String get memoryAllocation => 'Memory allocation';

  @override
  String get diskThroughput => 'Disk & throughput';

  @override
  String get diskUsed => 'Disk used';

  @override
  String get diskFree => 'Disk free';

  @override
  String get downlink => 'Downlink';

  @override
  String get uplink => 'Uplink';

  @override
  String get historicalTrends => 'HISTORICAL TRENDS';

  @override
  String lastWindow(String window) {
    return 'Last $window';
  }

  @override
  String get exportCsv => 'EXPORT CSV';

  @override
  String get exportJson => 'JSON';

  @override
  String get noSamplesInWindow => 'No samples in this window yet.';

  @override
  String savedPath(String path) {
    return 'Saved $path';
  }

  @override
  String get chartCpuMemory => 'CPU & memory';

  @override
  String samplesCount(int count) {
    return 'Samples: $count';
  }

  @override
  String get historyWindowH1 => '1H';

  @override
  String get historyWindowH6 => '6H';

  @override
  String get historyWindowH24 => '24H';

  @override
  String get historyWindowD7 => '7D';

  @override
  String get settingsGeneral => 'SETTINGS / GENERAL';

  @override
  String get preferences => 'Preferences';

  @override
  String get localDatabase => 'Local database';

  @override
  String get dbDescription =>
      'SQLite in application support; export below or from History.';

  @override
  String get sampling => 'Sampling';

  @override
  String get realTimeSamplingRate => 'Real-time sampling rate';

  @override
  String get interval1s => '1s';

  @override
  String get interval5s => '5s';

  @override
  String get interval10s => '10s';

  @override
  String get interval30s => '30s';

  @override
  String get retention => 'Retention';

  @override
  String get keepSamplesDays => 'Keep samples (days)';

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get maxRowsTrim => 'Max rows (trim oldest)';

  @override
  String sliderDaysLabel(int count) {
    return '$count d';
  }

  @override
  String get exportAllCsv => 'Export all stored samples (CSV)…';

  @override
  String savedPathRows(String path, int count) {
    return 'Saved $path ($count rows)';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '简体中文';

  @override
  String get fileTypeCsv => 'CSV';

  @override
  String get fileTypeJson => 'JSON';

  @override
  String get liveTelemetryFeed => 'LIVE TELEMETRY FEED';

  @override
  String get dashPerformanceTitle => 'Performance · CPU & memory';

  @override
  String get dashProcessSummaryTitle => 'Process summary';

  @override
  String get dashSamplesInWindow => 'Samples (this window)';

  @override
  String get dashSampleInterval => 'Sampling interval';

  @override
  String dashSecondsUnit(int count) {
    return '$count s';
  }

  @override
  String get dashAppUptime => 'App uptime';

  @override
  String get dashLastSample => 'Last sample';

  @override
  String get dashNoSampleYet => '—';

  @override
  String get dashOpenActivityMonitor => 'Open Activity Monitor';

  @override
  String get dashActivityMonitorUnavailable => 'Available on macOS only.';

  @override
  String get dashProcessTableTitle => 'Resource-intensive processes';

  @override
  String get dashProcessTableEmpty =>
      'No process list yet: the first sampling interval only warms up baselines, or App Sandbox may block enumerating other processes. Use Activity Monitor for full detail.';

  @override
  String get dashProcessTableSampleNote =>
      'CPU % is estimated over your sampling interval; may differ slightly from Activity Monitor.';

  @override
  String get dashProcessStatusHigh => 'HIGH';

  @override
  String get dashProcessStatusActive => 'ACTIVE';

  @override
  String get dashProcessStatusStable => 'STABLE';

  @override
  String get dashProcessStatusIdle => 'IDLE';

  @override
  String get dashProcessColName => 'Process';

  @override
  String get dashProcessColCpu => 'CPU %';

  @override
  String get dashProcessColMemory => 'Memory';

  @override
  String get dashProcessColStatus => 'Status';

  @override
  String get dashEventLogTitle => 'App log';

  @override
  String get dashEventLogStarted => 'Monitoring active since';

  @override
  String get dashEventLogFootnote =>
      'In-app telemetry only — not a full system event stream.';

  @override
  String get dashTooltipNotifications => 'Notifications';

  @override
  String get dashTooltipTelemetry => 'Telemetry status';

  @override
  String get dashTooltipProfile => 'Profile';

  @override
  String get dashTooltipLanguage => 'Language';

  @override
  String get dashThermalTitle => 'THERMAL PERFORMANCE';

  @override
  String get dashThermalSubtitle => 'Live CPU load (filled) vs memory % (line)';

  @override
  String get dashLegendLoadArea => 'CPU load';

  @override
  String get dashLegendMemoryLine => 'Memory %';

  @override
  String get dashAxisJustNow => 'NOW';

  @override
  String dashAxisMinutesShort(int n) {
    return '${n}m';
  }

  @override
  String get dashLogTelemetryStarted => 'Telemetry session started';

  @override
  String get dashLogSampleOk => 'Metric sample persisted';

  @override
  String get dashProcessNoRows => '—';
}
