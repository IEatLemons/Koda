import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Obsidian Monitor'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'V1.0.4 · Precision Instrument'**
  String get appSubtitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navMetrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get navMetrics;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @userAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get userAdmin;

  /// No description provided for @userRootAccess.
  ///
  /// In en, this message translates to:
  /// **'Root access'**
  String get userRootAccess;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String updatedAt(String time);

  /// No description provided for @collectingFirstSample.
  ///
  /// In en, this message translates to:
  /// **'Collecting first sample…'**
  String get collectingFirstSample;

  /// No description provided for @tileCpu.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get tileCpu;

  /// No description provided for @tileClusterLoad.
  ///
  /// In en, this message translates to:
  /// **'Cluster load'**
  String get tileClusterLoad;

  /// No description provided for @tileRam.
  ///
  /// In en, this message translates to:
  /// **'RAM'**
  String get tileRam;

  /// No description provided for @tileDisk.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get tileDisk;

  /// No description provided for @tileNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get tileNetwork;

  /// No description provided for @thermalTrendHint.
  ///
  /// In en, this message translates to:
  /// **'Thermal / load trend appears after more samples are stored.'**
  String get thermalTrendHint;

  /// No description provided for @loadMemoryLastHour.
  ///
  /// In en, this message translates to:
  /// **'Load & memory (last hour)'**
  String get loadMemoryLastHour;

  /// No description provided for @legendCpuPct.
  ///
  /// In en, this message translates to:
  /// **'CPU %'**
  String get legendCpuPct;

  /// No description provided for @legendMemoryPct.
  ///
  /// In en, this message translates to:
  /// **'Memory %'**
  String get legendMemoryPct;

  /// No description provided for @processMonitor.
  ///
  /// In en, this message translates to:
  /// **'PROCESS MONITOR'**
  String get processMonitor;

  /// No description provided for @precisionMetrics.
  ///
  /// In en, this message translates to:
  /// **'Precision Metrics'**
  String get precisionMetrics;

  /// No description provided for @statCpu.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get statCpu;

  /// No description provided for @statMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get statMemory;

  /// No description provided for @statNetworkSum.
  ///
  /// In en, this message translates to:
  /// **'Network ∑'**
  String get statNetworkSum;

  /// No description provided for @waitingTelemetry.
  ///
  /// In en, this message translates to:
  /// **'Waiting for telemetry…'**
  String get waitingTelemetry;

  /// No description provided for @utilizationOverview.
  ///
  /// In en, this message translates to:
  /// **'Utilization overview'**
  String get utilizationOverview;

  /// No description provided for @liveSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Live snapshot'**
  String get liveSnapshot;

  /// No description provided for @chartLabelCpu.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get chartLabelCpu;

  /// No description provided for @chartLabelRam.
  ///
  /// In en, this message translates to:
  /// **'RAM'**
  String get chartLabelRam;

  /// No description provided for @chartLabelDisk.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get chartLabelDisk;

  /// No description provided for @chartLabelNet.
  ///
  /// In en, this message translates to:
  /// **'Net*'**
  String get chartLabelNet;

  /// No description provided for @networkFootnote.
  ///
  /// In en, this message translates to:
  /// **'* Network ring is scaled heuristically vs 1 Gbps.'**
  String get networkFootnote;

  /// No description provided for @memoryAllocation.
  ///
  /// In en, this message translates to:
  /// **'Memory allocation'**
  String get memoryAllocation;

  /// No description provided for @diskThroughput.
  ///
  /// In en, this message translates to:
  /// **'Disk & throughput'**
  String get diskThroughput;

  /// No description provided for @diskUsed.
  ///
  /// In en, this message translates to:
  /// **'Disk used'**
  String get diskUsed;

  /// No description provided for @diskFree.
  ///
  /// In en, this message translates to:
  /// **'Disk free'**
  String get diskFree;

  /// No description provided for @downlink.
  ///
  /// In en, this message translates to:
  /// **'Downlink'**
  String get downlink;

  /// No description provided for @uplink.
  ///
  /// In en, this message translates to:
  /// **'Uplink'**
  String get uplink;

  /// No description provided for @historicalTrends.
  ///
  /// In en, this message translates to:
  /// **'HISTORICAL TRENDS'**
  String get historicalTrends;

  /// No description provided for @lastWindow.
  ///
  /// In en, this message translates to:
  /// **'Last {window}'**
  String lastWindow(String window);

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'EXPORT CSV'**
  String get exportCsv;

  /// No description provided for @exportJson.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get exportJson;

  /// No description provided for @noSamplesInWindow.
  ///
  /// In en, this message translates to:
  /// **'No samples in this window yet.'**
  String get noSamplesInWindow;

  /// No description provided for @savedPath.
  ///
  /// In en, this message translates to:
  /// **'Saved {path}'**
  String savedPath(String path);

  /// No description provided for @chartCpuMemory.
  ///
  /// In en, this message translates to:
  /// **'CPU & memory'**
  String get chartCpuMemory;

  /// No description provided for @samplesCount.
  ///
  /// In en, this message translates to:
  /// **'Samples: {count}'**
  String samplesCount(int count);

  /// No description provided for @historyWindowH1.
  ///
  /// In en, this message translates to:
  /// **'1H'**
  String get historyWindowH1;

  /// No description provided for @historyWindowH6.
  ///
  /// In en, this message translates to:
  /// **'6H'**
  String get historyWindowH6;

  /// No description provided for @historyWindowH24.
  ///
  /// In en, this message translates to:
  /// **'24H'**
  String get historyWindowH24;

  /// No description provided for @historyWindowD7.
  ///
  /// In en, this message translates to:
  /// **'7D'**
  String get historyWindowD7;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS / GENERAL'**
  String get settingsGeneral;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @localDatabase.
  ///
  /// In en, this message translates to:
  /// **'Local database'**
  String get localDatabase;

  /// No description provided for @dbDescription.
  ///
  /// In en, this message translates to:
  /// **'SQLite in application support; export below or from History.'**
  String get dbDescription;

  /// No description provided for @sampling.
  ///
  /// In en, this message translates to:
  /// **'Sampling'**
  String get sampling;

  /// No description provided for @realTimeSamplingRate.
  ///
  /// In en, this message translates to:
  /// **'Real-time sampling rate'**
  String get realTimeSamplingRate;

  /// No description provided for @interval1s.
  ///
  /// In en, this message translates to:
  /// **'1s'**
  String get interval1s;

  /// No description provided for @interval5s.
  ///
  /// In en, this message translates to:
  /// **'5s'**
  String get interval5s;

  /// No description provided for @interval10s.
  ///
  /// In en, this message translates to:
  /// **'10s'**
  String get interval10s;

  /// No description provided for @interval30s.
  ///
  /// In en, this message translates to:
  /// **'30s'**
  String get interval30s;

  /// No description provided for @retention.
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get retention;

  /// No description provided for @keepSamplesDays.
  ///
  /// In en, this message translates to:
  /// **'Keep samples (days)'**
  String get keepSamplesDays;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// No description provided for @maxRowsTrim.
  ///
  /// In en, this message translates to:
  /// **'Max rows (trim oldest)'**
  String get maxRowsTrim;

  /// No description provided for @sliderDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} d'**
  String sliderDaysLabel(int count);

  /// No description provided for @exportAllCsv.
  ///
  /// In en, this message translates to:
  /// **'Export all stored samples (CSV)…'**
  String get exportAllCsv;

  /// No description provided for @savedPathRows.
  ///
  /// In en, this message translates to:
  /// **'Saved {path} ({count} rows)'**
  String savedPathRows(String path, int count);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageChinese;

  /// No description provided for @fileTypeCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get fileTypeCsv;

  /// No description provided for @fileTypeJson.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get fileTypeJson;

  /// No description provided for @liveTelemetryFeed.
  ///
  /// In en, this message translates to:
  /// **'LIVE TELEMETRY FEED'**
  String get liveTelemetryFeed;

  /// No description provided for @dashPerformanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance · CPU & memory'**
  String get dashPerformanceTitle;

  /// No description provided for @dashProcessSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Process summary'**
  String get dashProcessSummaryTitle;

  /// No description provided for @dashSamplesInWindow.
  ///
  /// In en, this message translates to:
  /// **'Samples (this window)'**
  String get dashSamplesInWindow;

  /// No description provided for @dashSampleInterval.
  ///
  /// In en, this message translates to:
  /// **'Sampling interval'**
  String get dashSampleInterval;

  /// No description provided for @dashSecondsUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} s'**
  String dashSecondsUnit(int count);

  /// No description provided for @dashAppUptime.
  ///
  /// In en, this message translates to:
  /// **'App uptime'**
  String get dashAppUptime;

  /// No description provided for @dashLastSample.
  ///
  /// In en, this message translates to:
  /// **'Last sample'**
  String get dashLastSample;

  /// No description provided for @dashNoSampleYet.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get dashNoSampleYet;

  /// No description provided for @dashOpenActivityMonitor.
  ///
  /// In en, this message translates to:
  /// **'Open Activity Monitor'**
  String get dashOpenActivityMonitor;

  /// No description provided for @dashActivityMonitorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Available on macOS only.'**
  String get dashActivityMonitorUnavailable;

  /// No description provided for @dashProcessTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Resource-intensive processes'**
  String get dashProcessTableTitle;

  /// No description provided for @dashProcessTableEmpty.
  ///
  /// In en, this message translates to:
  /// **'No process list yet: the first sampling interval only warms up baselines, or App Sandbox may block enumerating other processes. Use Activity Monitor for full detail.'**
  String get dashProcessTableEmpty;

  /// No description provided for @dashProcessTableSampleNote.
  ///
  /// In en, this message translates to:
  /// **'CPU % is estimated over your sampling interval; may differ slightly from Activity Monitor.'**
  String get dashProcessTableSampleNote;

  /// No description provided for @dashProcessStatusHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get dashProcessStatusHigh;

  /// No description provided for @dashProcessStatusActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get dashProcessStatusActive;

  /// No description provided for @dashProcessStatusStable.
  ///
  /// In en, this message translates to:
  /// **'STABLE'**
  String get dashProcessStatusStable;

  /// No description provided for @dashProcessStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'IDLE'**
  String get dashProcessStatusIdle;

  /// No description provided for @dashProcessColName.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get dashProcessColName;

  /// No description provided for @dashProcessColCpu.
  ///
  /// In en, this message translates to:
  /// **'CPU %'**
  String get dashProcessColCpu;

  /// No description provided for @dashProcessColMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get dashProcessColMemory;

  /// No description provided for @dashProcessColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get dashProcessColStatus;

  /// No description provided for @dashEventLogTitle.
  ///
  /// In en, this message translates to:
  /// **'App log'**
  String get dashEventLogTitle;

  /// No description provided for @dashEventLogStarted.
  ///
  /// In en, this message translates to:
  /// **'Monitoring active since'**
  String get dashEventLogStarted;

  /// No description provided for @dashEventLogFootnote.
  ///
  /// In en, this message translates to:
  /// **'In-app telemetry only — not a full system event stream.'**
  String get dashEventLogFootnote;

  /// No description provided for @dashTooltipNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dashTooltipNotifications;

  /// No description provided for @dashTooltipTelemetry.
  ///
  /// In en, this message translates to:
  /// **'Telemetry status'**
  String get dashTooltipTelemetry;

  /// No description provided for @dashTooltipProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashTooltipProfile;

  /// No description provided for @dashTooltipLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get dashTooltipLanguage;

  /// No description provided for @dashThermalTitle.
  ///
  /// In en, this message translates to:
  /// **'THERMAL PERFORMANCE'**
  String get dashThermalTitle;

  /// No description provided for @dashThermalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live CPU load (filled) vs memory % (line)'**
  String get dashThermalSubtitle;

  /// No description provided for @dashLegendLoadArea.
  ///
  /// In en, this message translates to:
  /// **'CPU load'**
  String get dashLegendLoadArea;

  /// No description provided for @dashLegendMemoryLine.
  ///
  /// In en, this message translates to:
  /// **'Memory %'**
  String get dashLegendMemoryLine;

  /// No description provided for @dashAxisJustNow.
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get dashAxisJustNow;

  /// No description provided for @dashAxisMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{n}m'**
  String dashAxisMinutesShort(int n);

  /// No description provided for @dashLogTelemetryStarted.
  ///
  /// In en, this message translates to:
  /// **'Telemetry session started'**
  String get dashLogTelemetryStarted;

  /// No description provided for @dashLogSampleOk.
  ///
  /// In en, this message translates to:
  /// **'Metric sample persisted'**
  String get dashLogSampleOk;

  /// No description provided for @dashProcessNoRows.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get dashProcessNoRows;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
