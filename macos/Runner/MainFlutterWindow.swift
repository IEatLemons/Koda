import Cocoa
import FlutterMacOS
import Darwin

/// `mach/host_info.h` — not always visible to Swift; use numeric flavors.
private let kHostCpuLoad: host_flavor_t = 3
private let kHostVmInfo64: host_flavor_t = 4

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    SystemMetricsPlugin.register(with: flutterViewController.registrar(forPlugin: "SystemMetricsPlugin"))

    super.awakeFromNib()
  }
}

// MARK: - System metrics (MethodChannel)

final class SystemMetricsPlugin: NSObject, FlutterPlugin {
  private static var previousCpuLoad = host_cpu_load_info()
  private static var hasPreviousCpu = false
  private static let cpuLock = NSLock()

  /// Per-process CPU uses `proc_pidinfo`; second tick provides stable CPU % vs wall clock.
  private static var previousProcCpuNs: [pid_t: UInt64] = [:]
  private static var previousProcSampleAt: Date?
  private static let procSampleLock = NSLock()

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "obsidian_monitor/system_metrics",
      binaryMessenger: registrar.messenger
    )
    let instance = SystemMetricsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getMetrics":
      result(Self.collectMetrics())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func collectMetrics() -> [String: Any] {
    [
      "cpuPercent": cpuUsagePercent(),
      "memoryUsedBytes": memoryUsedBytes(),
      "memoryTotalBytes": memoryTotalBytes(),
      "diskUsedBytes": diskUsedBytes(),
      "diskTotalBytes": diskTotalBytes(),
      "networkInBytes": networkBytes().0,
      "networkOutBytes": networkBytes().1,
      "topProcesses": collectTopProcesses(limit: 8),
    ]
  }

  private static func cpuUsagePercent() -> Double {
    var load = host_cpu_load_info()
    var count = mach_msg_type_number_t(
      MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size
    )
    let kr = withUnsafeMutablePointer(to: &load) {
      $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
        host_statistics(mach_host_self(), kHostCpuLoad, $0, &count)
      }
    }
    guard kr == KERN_SUCCESS else { return 0 }

    cpuLock.lock()
    defer { cpuLock.unlock() }

    if !hasPreviousCpu {
      previousCpuLoad = load
      hasPreviousCpu = true
      return 0
    }

    let prev = previousCpuLoad
    previousCpuLoad = load

    let u = Double(load.cpu_ticks.0 &- prev.cpu_ticks.0)
    let s = Double(load.cpu_ticks.1 &- prev.cpu_ticks.1)
    let i = Double(load.cpu_ticks.2 &- prev.cpu_ticks.2)
    let n = Double(load.cpu_ticks.3 &- prev.cpu_ticks.3)
    let total = u + s + i + n
    guard total > 0 else { return 0 }
    return 100.0 * (u + s + n) / total
  }

  private static func memoryTotalBytes() -> UInt64 {
    var mem: UInt64 = 0
    var len = size_t(MemoryLayout<UInt64>.size)
    sysctlbyname("hw.memsize", &mem, &len, nil, 0)
    return mem
  }

  private static func memoryUsedBytes() -> UInt64 {
    var stats = vm_statistics64()
    var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
    let kr = withUnsafeMutablePointer(to: &stats) {
      $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
        host_statistics64(mach_host_self(), kHostVmInfo64, $0, &count)
      }
    }
    guard kr == KERN_SUCCESS else { return 0 }

    var pageSize: vm_size_t = 0
    host_page_size(mach_host_self(), &pageSize)
    let page = UInt64(pageSize)

    let usedPages =
      UInt64(stats.active_count) +
      UInt64(stats.wire_count) +
      UInt64(stats.compressor_page_count)

    let totalMem = memoryTotalBytes()
    let approx = usedPages * page
    return min(approx, totalMem)
  }

  private static func diskBytes() -> (UInt64, UInt64) {
    let path = NSHomeDirectory()
    do {
      let attrs = try FileManager.default.attributesOfFileSystem(forPath: path)
      let free = (attrs[FileAttributeKey.systemFreeSize] as? NSNumber)?.uint64Value ?? 0
      let total = (attrs[FileAttributeKey.systemSize] as? NSNumber)?.uint64Value ?? 0
      let used = total >= free ? total - free : 0
      return (used, total == 0 ? 1 : total)
    } catch {
      return (0, 1)
    }
  }

  private static func diskUsedBytes() -> UInt64 { diskBytes().0 }
  private static func diskTotalBytes() -> UInt64 { diskBytes().1 }

  private static func networkBytes() -> (UInt64, UInt64) {
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0, let first = ifaddr else { return (0, 0) }
    defer { freeifaddrs(ifaddr) }

    var inB: UInt64 = 0
    var outB: UInt64 = 0
    var ptr: UnsafeMutablePointer<ifaddrs>? = first

    while let cur = ptr {
      let iface = cur.pointee
      let name = String(cString: iface.ifa_name)
      if name.hasPrefix("lo") {
        ptr = iface.ifa_next
        continue
      }
      if iface.ifa_addr?.pointee.sa_family == UInt8(AF_LINK), let data = iface.ifa_data {
        let d = data.assumingMemoryBound(to: if_data.self).pointee
        inB += UInt64(d.ifi_ibytes)
        outB += UInt64(d.ifi_obytes)
      }
      ptr = iface.ifa_next
    }
    return (inB, outB)
  }

  // MARK: - Top processes (libproc)

  private static func collectTopProcesses(limit: Int) -> [[String: Any]] {
    procSampleLock.lock()
    defer { procSampleLock.unlock() }

    let now = Date()
    let bytesNeeded = proc_listpids(UInt32(PROC_ALL_PIDS), 0, nil, 0)
    guard bytesNeeded > 0 else {
      return []
    }

    let pidStride = MemoryLayout<pid_t>.stride
    let maxPids = Int(bytesNeeded) / pidStride
    guard maxPids > 0 else { return [] }

    var pidBuffer = [pid_t](repeating: 0, count: maxPids)
    let filled = proc_listpids(
      UInt32(PROC_ALL_PIDS), 0, &pidBuffer, Int32(bytesNeeded))
    guard filled > 0 else { return [] }

    let nPids = Int(filled) / pidStride
    struct Snap {
      let name: String
      let totalNs: UInt64
      let resident: UInt64
    }

    var current: [pid_t: Snap] = [:]
    current.reserveCapacity(nPids)

    for i in 0..<nPids {
      let pid = pidBuffer[i]
      if pid <= 0 { continue }
      var task = proc_taskinfo()
      let want = Int32(MemoryLayout<proc_taskinfo>.size)
      let got = proc_pidinfo(pid, Int32(PROC_PIDTASKINFO), 0, &task, want)
      if got != want { continue }
      let totalNs = task.pti_total_user &+ task.pti_total_system
      let snap = Snap(
        name: procDisplayName(pid: pid),
        totalNs: totalNs,
        resident: task.pti_resident_size)
      current[pid] = snap
    }

    let prevWall = previousProcSampleAt
    let prevMap = previousProcCpuNs
    previousProcCpuNs = Dictionary(uniqueKeysWithValues: current.map {
      ($0.key, $0.value.totalNs)
    })
    previousProcSampleAt = now

    guard let wallStart = prevWall, wallStart <= now, !prevMap.isEmpty else {
      return []
    }

    let wall = now.timeIntervalSince(wallStart)
    guard wall > 0.001 else { return [] }

    let ncpu = max(1, ProcessInfo.processInfo.processorCount)
    var scored: [(name: String, cpu: Double, mem: UInt64)] = []
    scored.reserveCapacity(min(current.count, 64))

    for (pid, snap) in current {
      guard let prevNs = prevMap[pid] else { continue }
      let delta = snap.totalNs >= prevNs ? snap.totalNs &- prevNs : 0
      let pct = 100.0 * (Double(delta) / 1.0e9) / wall / Double(ncpu)
      if pct.isFinite {
        scored.append((snap.name, min(max(pct, 0), 500), snap.resident))
      }
    }

    scored.sort { $0.cpu > $1.cpu }
    return scored.prefix(limit).map {
      let memInt = $0.mem > UInt64(Int.max) ? Int.max : Int($0.mem)
      return ["name": $0.name, "cpuPercent": $0.cpu, "memoryBytes": memInt] as [String: Any]
    }
  }

  private static func procDisplayName(pid: pid_t) -> String {
    var buf = [CChar](repeating: 0, count: 512)
    if proc_name(pid, &buf, UInt32(buf.count)) > 0 {
      let s = String(cString: buf)
      if !s.isEmpty { return s }
    }
    // PROC_PIDPATHINFO_MAXSIZE = 4 * MAXPATHLEN; fixed size avoids macro visibility in Swift.
    var pbuf = [CChar](repeating: 0, count: 4096)
    if proc_pidpath(pid, &pbuf, UInt32(pbuf.count)) > 0 {
      let path = String(cString: pbuf)
      if !path.isEmpty {
        return URL(fileURLWithPath: path).lastPathComponent
      }
    }
    return "pid \(pid)"
  }
}
