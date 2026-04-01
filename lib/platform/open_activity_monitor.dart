import 'dart:io';

/// Opens macOS Activity Monitor. No-op on other platforms.
Future<void> openActivityMonitor() async {
  if (!Platform.isMacOS) return;
  try {
    await Process.run('open', ['-a', 'Activity Monitor']);
  } catch (_) {
    // Ignore if Activity Monitor missing or sandbox blocks.
  }
}
