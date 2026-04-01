import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/settings_controller.dart';
import 'l10n/app_localizations.dart';
import 'data/db/app_database.dart';
import 'data/metrics_repository.dart';
import 'monitoring/monitoring_service.dart';
import 'theme/app_theme.dart';
import 'ui/shell/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final repository = MetricsRepository(db);
  final settings = SettingsController();
  await settings.load();

  final monitoring = MonitoringService(
    repository: repository,
    settings: settings,
  );
  monitoring.start();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        Provider<MetricsRepository>.value(value: repository),
        ChangeNotifierProvider<SettingsController>.value(value: settings),
        ChangeNotifierProvider<MonitoringService>.value(value: monitoring),
      ],
      child: const ObsidianMonitorApp(),
    ),
  );
}

class ObsidianMonitorApp extends StatelessWidget {
  const ObsidianMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return MaterialApp(
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: settings.appLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    );
  }
}
