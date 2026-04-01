import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    primary: AppColors.primary,
    onPrimary: Color(0xFF003064),
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    tertiary: AppColors.tertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    error: AppColors.error,
    outline: Color(0xFF8B90A0),
    outlineVariant: AppColors.outlineVariant,
  );

  final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
    bodyColor: AppColors.onSurface,
    displayColor: AppColors.onSurface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.surface,
    textTheme: textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      displaySmall: textTheme.displaySmall?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelSmall: textTheme.labelSmall?.copyWith(
        fontSize: 11,
        letterSpacing: 0.8,
        color: AppColors.onSurfaceVariant,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainerHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.transparent,
      selectedIconTheme: const IconThemeData(color: AppColors.primary),
      unselectedIconTheme: IconThemeData(color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
      selectedLabelTextStyle: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600),
      unselectedLabelTextStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return AppColors.onPrimaryContainer;
          return AppColors.onSurfaceVariant;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return AppColors.primary.withValues(alpha: 0.15);
          return AppColors.surfaceContainerHigh;
        }),
      ),
    ),
  );
}
