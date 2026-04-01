import 'package:flutter/material.dart';

/// Design tokens from ventura_dark/DESIGN.md (Obsidian / Material 3 dark).
abstract final class AppColors {
  static const Color surface = Color(0xFF131315);
  static const Color surfaceContainerLow = Color(0xFF1B1B1D);
  static const Color surfaceContainer = Color(0xFF1F1F21);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2C);
  static const Color surfaceContainerHighest = Color(0xFF353437);
  static const Color surfaceBright = Color(0xFF39393B);
  static const Color onSurface = Color(0xFFE4E2E4);
  static const Color onSurfaceVariant = Color(0xFFC1C6D7);
  static const Color outlineVariant = Color(0xFF414755);

  static const Color primary = Color(0xFFAAC7FF);
  static const Color primaryContainer = Color(0xFF3E90FF);
  static const Color onPrimaryContainer = Color(0xFF002957);

  static const Color secondary = Color(0xFF47E266);
  static const Color secondaryContainer = Color(0xFF09BF49);
  static const Color onSecondary = Color(0xFF003910);

  static const Color tertiary = Color(0xFFE9C400);
  static const Color tertiaryContainer = Color(0xFFC9A800);

  static const Color error = Color(0xFFFFB4AB);

  /// Sidebar / glass: ~60% opacity applied in widget layer.
  static const Color sidebarTint = Color(0x991B1B1D);

  /// Main canvas for dashboard (near-black, reference layout).
  static const Color dashboardCanvas = Color(0xFF050507);
}
