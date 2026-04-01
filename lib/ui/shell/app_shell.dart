import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../l10n/app_localizations.dart';
import '../../features/history/history_page.dart';
import '../../features/metrics/metrics_page.dart';
import '../../features/settings/settings_page.dart';
import '../../theme/app_colors.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  List<_NavSpec> _navItems(AppLocalizations l10n) => [
        _NavSpec(icon: Icons.dashboard_rounded, label: l10n.navDashboard),
        _NavSpec(icon: Icons.show_chart_rounded, label: l10n.navMetrics),
        _NavSpec(icon: Icons.history_rounded, label: l10n.navHistory),
        _NavSpec(icon: Icons.settings_rounded, label: l10n.navSettings),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destinations = _navItems(l10n);
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 240,
            child: Material(
              color: AppColors.sidebarTint,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _trafficDot(const Color(0xFFFF5F56)),
                        const SizedBox(width: 8),
                        _trafficDot(const Color(0xFFFFBD2E)),
                        const SizedBox(width: 8),
                        _trafficDot(const Color(0xFF27C93F)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.appSubtitle,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: destinations.length,
                      itemBuilder: (context, i) {
                        final d = destinations[i];
                        final selected = i == _index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Material(
                            color: selected
                                ? AppColors.primary.withValues(alpha: 0.10)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => setState(() => _index = i),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: selected ? AppColors.primary : Colors.transparent,
                                      borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    d.icon,
                                    size: 22,
                                    color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      d.label,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                            color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1, color: Color(0x1A414755)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.surfaceContainerHighest,
                          child: Icon(Icons.person_rounded, color: AppColors.primary.withValues(alpha: 0.9)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.userAdmin,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                l10n.userRootAccess,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: _index == 0 ? AppColors.dashboardCanvas : AppColors.surface,
              child: IndexedStack(
                index: _index,
                children: const [
                  DashboardPage(),
                  MetricsPage(),
                  HistoryPage(),
                  SettingsPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _trafficDot(Color c) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
}

class _NavSpec {
  const _NavSpec({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
