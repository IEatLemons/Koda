// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Obsidian 监视器';

  @override
  String get appSubtitle => 'V1.0.4 · 精密仪表';

  @override
  String get navDashboard => '总览';

  @override
  String get navMetrics => '指标';

  @override
  String get navHistory => '历史';

  @override
  String get navSettings => '设置';

  @override
  String get userAdmin => '管理员';

  @override
  String get userRootAccess => '根权限';

  @override
  String get dashboardTitle => '总览';

  @override
  String updatedAt(String time) {
    return '更新于 $time';
  }

  @override
  String get collectingFirstSample => '正在采集首条样本…';

  @override
  String get tileCpu => 'CPU';

  @override
  String get tileClusterLoad => '集群负载';

  @override
  String get tileRam => '内存';

  @override
  String get tileDisk => '磁盘';

  @override
  String get tileNetwork => '网络';

  @override
  String get thermalTrendHint => '存储更多样本后将显示温度/负载趋势。';

  @override
  String get loadMemoryLastHour => '负载与内存（近一小时）';

  @override
  String get legendCpuPct => 'CPU %';

  @override
  String get legendMemoryPct => '内存 %';

  @override
  String get processMonitor => '进程监视';

  @override
  String get precisionMetrics => '精密指标';

  @override
  String get statCpu => 'CPU';

  @override
  String get statMemory => '内存';

  @override
  String get statNetworkSum => '网络 ∑';

  @override
  String get waitingTelemetry => '等待遥测数据…';

  @override
  String get utilizationOverview => '利用率概览';

  @override
  String get liveSnapshot => '实时快照';

  @override
  String get chartLabelCpu => 'CPU';

  @override
  String get chartLabelRam => '内存';

  @override
  String get chartLabelDisk => '磁盘';

  @override
  String get chartLabelNet => '网*';

  @override
  String get networkFootnote => '* 网络环相对 1 Gbps 启发式缩放。';

  @override
  String get memoryAllocation => '内存占用';

  @override
  String get diskThroughput => '磁盘与吞吐';

  @override
  String get diskUsed => '已用磁盘';

  @override
  String get diskFree => '可用磁盘';

  @override
  String get downlink => '下行';

  @override
  String get uplink => '上行';

  @override
  String get historicalTrends => '历史趋势';

  @override
  String lastWindow(String window) {
    return '最近 $window';
  }

  @override
  String get exportCsv => '导出 CSV';

  @override
  String get exportJson => 'JSON';

  @override
  String get noSamplesInWindow => '此时间窗口内尚无数据点。';

  @override
  String savedPath(String path) {
    return '已保存 $path';
  }

  @override
  String get chartCpuMemory => 'CPU 与内存';

  @override
  String samplesCount(int count) {
    return '样本数：$count';
  }

  @override
  String get historyWindowH1 => '1小时';

  @override
  String get historyWindowH6 => '6小时';

  @override
  String get historyWindowH24 => '24小时';

  @override
  String get historyWindowD7 => '7天';

  @override
  String get settingsGeneral => '设置 / 常规';

  @override
  String get preferences => '偏好';

  @override
  String get localDatabase => '本地数据库';

  @override
  String get dbDescription => 'SQLite 位于应用支持目录；可在下方或历史页导出。';

  @override
  String get sampling => '采样';

  @override
  String get realTimeSamplingRate => '实时采样频率';

  @override
  String get interval1s => '1秒';

  @override
  String get interval5s => '5秒';

  @override
  String get interval10s => '10秒';

  @override
  String get interval30s => '30秒';

  @override
  String get retention => '保留';

  @override
  String get keepSamplesDays => '保留样本（天）';

  @override
  String daysCount(int count) {
    return '$count 天';
  }

  @override
  String get maxRowsTrim => '最大行数（删最旧）';

  @override
  String sliderDaysLabel(int count) {
    return '$count 天';
  }

  @override
  String get exportAllCsv => '导出全部已存样本（CSV）…';

  @override
  String savedPathRows(String path, int count) {
    return '已保存 $path（$count 行）';
  }

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '简体中文';

  @override
  String get fileTypeCsv => 'CSV';

  @override
  String get fileTypeJson => 'JSON';

  @override
  String get liveTelemetryFeed => '实时遥测';

  @override
  String get dashPerformanceTitle => '性能 · CPU 与内存';

  @override
  String get dashProcessSummaryTitle => '进程摘要';

  @override
  String get dashSamplesInWindow => '本窗口样本数';

  @override
  String get dashSampleInterval => '采样间隔';

  @override
  String dashSecondsUnit(int count) {
    return '$count 秒';
  }

  @override
  String get dashAppUptime => '应用运行时长';

  @override
  String get dashLastSample => '最近样本';

  @override
  String get dashNoSampleYet => '—';

  @override
  String get dashOpenActivityMonitor => '打开活动监视器';

  @override
  String get dashActivityMonitorUnavailable => '仅 macOS 可用。';

  @override
  String get dashProcessTableTitle => '高资源进程';

  @override
  String get dashProcessTableEmpty =>
      '暂无进程列表数据：首个采样间隔仅建立基线，或受沙箱限制无法枚举其他进程。可在活动监视器中查看详情。';

  @override
  String get dashProcessTableSampleNote => 'CPU 占比为采样间隔内估算值，可能与活动监视器略有差异。';

  @override
  String get dashProcessStatusHigh => '高';

  @override
  String get dashProcessStatusActive => '活跃';

  @override
  String get dashProcessStatusStable => '平稳';

  @override
  String get dashProcessStatusIdle => '空闲';

  @override
  String get dashProcessColName => '进程';

  @override
  String get dashProcessColCpu => 'CPU %';

  @override
  String get dashProcessColMemory => '内存';

  @override
  String get dashProcessColStatus => '状态';

  @override
  String get dashEventLogTitle => '应用日志';

  @override
  String get dashEventLogStarted => '监视自以下时间起运行';

  @override
  String get dashEventLogFootnote => '仅为应用内遥测日志，非完整系统事件流。';

  @override
  String get dashTooltipNotifications => '通知';

  @override
  String get dashTooltipTelemetry => '遥测状态';

  @override
  String get dashTooltipProfile => '用户';

  @override
  String get dashTooltipLanguage => '语言';

  @override
  String get dashThermalTitle => '热工性能';

  @override
  String get dashThermalSubtitle => '实时 CPU 负载（面积）与内存占比（折线）';

  @override
  String get dashLegendLoadArea => 'CPU 负载';

  @override
  String get dashLegendMemoryLine => '内存 %';

  @override
  String get dashAxisJustNow => '此刻';

  @override
  String dashAxisMinutesShort(int n) {
    return '$n 分';
  }

  @override
  String get dashLogTelemetryStarted => '遥测会话已启动';

  @override
  String get dashLogSampleOk => '指标样本已写入';

  @override
  String get dashProcessNoRows => '—';
}
