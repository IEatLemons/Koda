# Obsidian Monitor

面向 macOS 的 Flutter 桌面应用：系统指标采集、本地存储（SQLite / Drift）与图表展示；数据可导出，界面支持中/英（`flutter gen-l10n`）。

## 环境要求

- Flutter **stable**（需满足 `pubspec.yaml` 中的 **Dart `sdk: ^3.11.3`**；以 `flutter --version` 为准）
- Xcode（含 Command Line Tools），用于构建 **macOS** 目标
- CocoaPods（`macos/Podfile`）：首次克隆后需在 `macos/` 下安装原生依赖

## 快速开始

```bash
# 安装 Dart / Flutter 依赖
flutter pub get

# macOS 原生依赖（首次或 Podfile 变更后）
cd macos && pod install && cd ..

# 运行（桌面）
flutter run -d macos
```

## 代码生成

本项目使用 **Drift** 访问 SQLite；若修改了 `lib/data/db/` 下表结构或 `@DriftDatabase` 相关定义，需重新生成 `*.g.dart`：

```bash
dart run build_runner build --delete-conflicting-outputs
```

修改 `lib/l10n/*.arb` 后更新本地化：

```bash
flutter gen-l10n
```

（`pubspec.yaml` 中已开启 `flutter: generate: true`，部分工作流也会在构建时触发生成。）

## 构建发布

```bash
flutter build macos --release
```

产物位于 `build/macos/Build/Products/Release/`（`.app`）。

## sqlite3（macOS）

`pubspec.yaml` 的 `hooks.user_defines` 将 **sqlite3** 设为使用**系统自带** `libsqlite3`，避免构建时从网络拉取预编译二进制；若在其它平台扩展，请查阅 [package:sqlite3 文档](https://pub.dev/packages/sqlite3) 并按平台配置。

## 仓库说明

- 忽略构建产物、`.dart_tool/`、`macos/Pods/` 等；请勿提交密钥或 `.env`（参见根目录 `.gitignore`）。
- 应用包名：`obsidian_monitor`（见 `pubspec.yaml`）。

## 许可证

尚未附带 `LICENSE`；对外分发或开源前请自行选用并补充许可文件。
