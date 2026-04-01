String formatBytes(num b, [int decimals = 1]) {
  if (b < 1024) return '${b.toStringAsFixed(0)} B';
  const u = ['KB', 'MB', 'GB', 'TB'];
  var v = b / 1024.0;
  var i = 0;
  while (v >= 1024 && i < u.length - 1) {
    v /= 1024;
    i++;
  }
  return '${v.toStringAsFixed(decimals)} ${u[i]}';
}

String formatBps(double bps, [int decimals = 1]) {
  return '${formatBytes(bps, decimals)}/s';
}
