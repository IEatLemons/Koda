import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static const _kSampleInterval = 'sample_interval_sec';
  static const _kRetentionDays = 'retention_days';
  static const _kMaxSamples = 'max_samples';
  static const _kLocaleCode = 'locale_code';

  static const allowedSampleIntervals = [1, 5, 10, 30];

  int sampleIntervalSeconds = 5;
  int retentionDays = 14;
  int maxSamples = 200000;

  /// Empty: follow system. Otherwise `en` or `zh`.
  String localeCode = '';

  Locale? get appLocale =>
      localeCode.isEmpty ? null : Locale(localeCode);

  static int nearestSampleInterval(int v) {
    return allowedSampleIntervals.reduce(
      (a, b) => (v - a).abs() <= (v - b).abs() ? a : b,
    );
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    sampleIntervalSeconds = nearestSampleInterval(p.getInt(_kSampleInterval) ?? 5);
    retentionDays = p.getInt(_kRetentionDays) ?? 14;
    maxSamples = p.getInt(_kMaxSamples) ?? 200000;
    final raw = p.getString(_kLocaleCode) ?? '';
    localeCode = (raw == 'en' || raw == 'zh') ? raw : '';
    notifyListeners();
  }

  Future<void> setSampleIntervalSeconds(int v) async {
    final clamped = v.clamp(1, 3600);
    sampleIntervalSeconds = clamped;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kSampleInterval, clamped);
    notifyListeners();
  }

  Future<void> setRetentionDays(int v) async {
    final clamped = v.clamp(1, 3650);
    retentionDays = clamped;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kRetentionDays, clamped);
    notifyListeners();
  }

  Future<void> setMaxSamples(int v) async {
    final clamped = v.clamp(1000, 5000000);
    maxSamples = clamped;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kMaxSamples, clamped);
    notifyListeners();
  }

  Future<void> setLocaleCode(String code) async {
    final normalized = (code == 'en' || code == 'zh') ? code : '';
    localeCode = normalized;
    final p = await SharedPreferences.getInstance();
    if (normalized.isEmpty) {
      await p.remove(_kLocaleCode);
    } else {
      await p.setString(_kLocaleCode, normalized);
    }
    notifyListeners();
  }
}
