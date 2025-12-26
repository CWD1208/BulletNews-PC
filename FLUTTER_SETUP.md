# Flutter 环境搭建指南

本文档详细说明如何在不同操作系统上搭建 Flutter 开发环境。

## 目录

- [系统要求](#系统要求)
- [macOS 安装步骤](#macos-安装步骤)
- [Windows 安装步骤](#windows-安装步骤)
- [Linux 安装步骤](#linux-安装步骤)
- [环境配置](#环境配置)
- [验证安装](#验证安装)
- [IDE 配置](#ide-配置)
- [常见问题](#常见问题)

---

## 系统要求

### macOS
- **操作系统**: macOS 10.14 (Mojave) 或更高版本
- **磁盘空间**: 至少 2.8 GB（不包括 IDE/工具的磁盘空间）
- **工具**: 
  - Xcode（用于 iOS 开发）
  - Android Studio（用于 Android 开发）

### Windows
- **操作系统**: Windows 10 或更高版本（64位）
- **磁盘空间**: 至少 1.32 GB（不包括 IDE/工具的磁盘空间）
- **工具**: 
  - Git for Windows
  - Android Studio

### Linux
- **操作系统**: 64位 Linux 系统
- **磁盘空间**: 至少 600 MB（不包括 IDE/工具的磁盘空间）
- **工具**: 
  - Android Studio

---

## macOS 安装步骤

### 1. 安装 Flutter SDK

#### 方法一：使用 Git（推荐）

```bash
# 克隆 Flutter 仓库
git clone https://github.com/flutter/flutter.git -b stable

# 或者使用国内镜像（如果 GitHub 访问较慢）
git clone https://gitee.com/mirrors/Flutter.git -b stable
```

#### 方法二：下载 ZIP 文件

1. 访问 [Flutter 官网](https://docs.flutter.dev/get-started/install/macos)
2. 下载最新的稳定版本 ZIP 文件
3. 解压到您想要安装的位置，例如：
   ```bash
   cd ~/development
   unzip ~/Downloads/flutter_macos_*.zip
   ```

### 2. 配置环境变量

将 Flutter 添加到 PATH 环境变量中：

```bash
# 编辑 shell 配置文件（根据您使用的 shell 选择）
# 如果是 zsh（macOS 默认）
nano ~/.zshrc

# 如果是 bash
nano ~/.bash_profile
```

在文件末尾添加以下内容（请将 `[PATH_TO_FLUTTER]` 替换为您的 Flutter 安装路径）：

```bash
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"
```

例如，如果 Flutter 安装在 `~/development/flutter`：

```bash
export PATH="$PATH:$HOME/development/flutter/bin"
```

保存文件后，重新加载配置：

```bash
# zsh
source ~/.zshrc

# bash
source ~/.bash_profile
```

### 3. 安装 Xcode

1. 从 App Store 安装 Xcode
2. 安装 Xcode 命令行工具：
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```
3. 接受 Xcode 许可协议：
   ```bash
   sudo xcodebuild -license accept
   ```

### 4. 安装 CocoaPods（iOS 开发必需）

```bash
sudo gem install cocoapods
```

### 5. 安装 Android Studio

1. 下载并安装 [Android Studio](https://developer.android.com/studio)
2. 启动 Android Studio，完成设置向导
3. 安装 Android SDK：
   - 打开 Android Studio
   - 进入 Preferences（设置）> Appearance & Behavior > System Settings > Android SDK
   - 在 SDK Platforms 标签页中，勾选 Android SDK Platform
   - 在 SDK Tools 标签页中，勾选：
     - Android SDK Build-Tools
     - Android SDK Command-line Tools
     - Android SDK Platform-Tools
     - Android Emulator
   - 点击 Apply 安装

### 6. 配置 Android 环境变量

在 `~/.zshrc` 或 `~/.bash_profile` 中添加：

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
```

重新加载配置：

```bash
source ~/.zshrc  # 或 source ~/.bash_profile
```

---

## Windows 安装步骤

### 1. 安装 Git

1. 下载并安装 [Git for Windows](https://git-scm.com/download/win)
2. 在安装过程中，选择 "Use Git from the Windows Command Prompt"

### 2. 安装 Flutter SDK

#### 方法一：使用 Git

```bash
git clone https://github.com/flutter/flutter.git -b stable
```

#### 方法二：下载 ZIP 文件

1. 访问 [Flutter 官网](https://docs.flutter.dev/get-started/install/windows)
2. 下载最新的稳定版本 ZIP 文件
3. 解压到您想要安装的位置，例如：`C:\src\flutter`

### 3. 配置环境变量

1. 在开始菜单搜索 "环境变量"
2. 点击 "编辑系统环境变量"
3. 点击 "环境变量" 按钮
4. 在 "用户变量" 或 "系统变量" 中找到 Path，点击 "编辑"
5. 点击 "新建"，添加 Flutter 的 bin 目录路径，例如：`C:\src\flutter\bin`
6. 点击 "确定" 保存所有更改

### 4. 安装 Android Studio

1. 下载并安装 [Android Studio](https://developer.android.com/studio)
2. 启动 Android Studio，完成设置向导
3. 安装 Android SDK（参考 macOS 步骤 5）

### 5. 配置 Android 环境变量

1. 在环境变量中添加：
   - 变量名：`ANDROID_HOME`
   - 变量值：`C:\Users\<您的用户名>\AppData\Local\Android\Sdk`
2. 在 Path 中添加：
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\tools`
   - `%ANDROID_HOME%\tools\bin`

---

## Linux 安装步骤

### 1. 安装依赖

```bash
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
```

### 2. 安装 Flutter SDK

```bash
# 克隆 Flutter 仓库
git clone https://github.com/flutter/flutter.git -b stable

# 或者下载 ZIP 文件并解压
```

### 3. 配置环境变量

编辑 `~/.bashrc` 文件：

```bash
nano ~/.bashrc
```

添加以下内容（替换为您的 Flutter 安装路径）：

```bash
export PATH="$PATH:$HOME/development/flutter/bin"
```

重新加载配置：

```bash
source ~/.bashrc
```

### 4. 安装 Android Studio

参考 macOS 步骤 5

### 5. 配置 Android 环境变量

在 `~/.bashrc` 中添加：

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
```

---

## 环境配置

### 运行 Flutter Doctor

安装完成后，运行以下命令检查环境配置：

```bash
flutter doctor
```

这个命令会检查您的环境并显示任何需要解决的问题。根据输出信息修复问题。

### 常见问题修复

#### 1. 接受 Android 许可协议

```bash
flutter doctor --android-licenses
```

#### 2. 更新 Flutter

```bash
flutter upgrade
```

#### 3. 清理 Flutter 缓存

```bash
flutter clean
flutter pub get
```

---

## 验证安装

### 1. 检查 Flutter 版本

```bash
flutter --version
```

### 2. 检查 Flutter Doctor

```bash
flutter doctor -v
```

确保所有检查项都显示 ✓（绿色对勾）。

### 3. 创建测试项目

```bash
flutter create test_app
cd test_app
flutter run
```

---

## IDE 配置

### VS Code（推荐）

1. 安装 VS Code
2. 安装 Flutter 扩展：
   - 打开 VS Code
   - 进入扩展市场（Cmd/Ctrl + Shift + X）
   - 搜索并安装 "Flutter" 扩展（会自动安装 Dart 扩展）

### Android Studio / IntelliJ IDEA

1. 打开 Android Studio
2. 进入 Preferences（设置）> Plugins
3. 搜索并安装 "Flutter" 插件（会自动安装 Dart 插件）
4. 重启 IDE

### 配置 VS Code

1. 打开命令面板（Cmd/Ctrl + Shift + P）
2. 输入 "Flutter: Select Device" 选择设备
3. 按 F5 或点击运行按钮启动应用

---

## 常见问题

### 1. Flutter 命令未找到

**问题**: 运行 `flutter` 命令时提示 "command not found"

**解决方案**:
- 检查 PATH 环境变量是否正确配置
- 确认 Flutter 安装路径正确
- 重新加载 shell 配置（`source ~/.zshrc` 或 `source ~/.bash_profile`）

### 2. Android SDK 未找到

**问题**: Flutter doctor 显示 Android SDK 未安装

**解决方案**:
- 确认 Android Studio 已正确安装
- 检查 ANDROID_HOME 环境变量是否正确设置
- 在 Android Studio 中安装 Android SDK Platform

### 3. CocoaPods 安装失败（macOS）

**问题**: 安装 CocoaPods 时出现权限错误

**解决方案**:
```bash
# 使用 Homebrew 安装
brew install cocoapods

# 或者使用 sudo
sudo gem install cocoapods
```

### 4. 网络连接问题（中国用户）

**问题**: 下载 Flutter 或依赖包时速度慢或失败

**解决方案**:
- 使用国内镜像源，在环境变量中添加：
  ```bash
  # 在 ~/.zshrc 或 ~/.bash_profile 中添加
  export PUB_HOSTED_URL=https://pub.flutter-io.cn
  export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
  ```
- 使用 Gitee 镜像克隆 Flutter：
  ```bash
  git clone https://gitee.com/mirrors/Flutter.git -b stable
  ```

### 5. Xcode 命令行工具问题（macOS）

**问题**: Xcode 命令行工具未正确配置

**解决方案**:
```bash
sudo xcode-select --reset
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### 6. 许可证问题

**问题**: Android 许可证未接受

**解决方案**:
```bash
flutter doctor --android-licenses
# 按 y 接受所有许可证
```

---

## 项目特定配置

### 当前项目要求

根据 `pubspec.yaml`，本项目需要：
- **Dart SDK**: ^3.7.2
- **Flutter SDK**: 最新稳定版

### 安装项目依赖

在项目根目录运行：

```bash
flutter pub get
```

### 运行项目

```bash
# 检查可用设备
flutter devices

# 运行项目
flutter run

# 在特定设备上运行
flutter run -d <device-id>
```

### 构建项目

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS（仅 macOS）
flutter build ios
```

---

## 下一步

环境搭建完成后，您可以：

1. 阅读 [Flutter 官方文档](https://docs.flutter.dev/)
2. 查看项目 README.md 了解项目结构
3. 运行 `flutter doctor` 确保所有工具已正确配置
4. 开始开发！

---

## 参考资源

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言文档](https://dart.dev/)
- [Flutter 中文社区](https://flutter.cn/)
- [Flutter 包管理](https://pub.dev/)

---

**最后更新**: 2024年

**注意**: 本文档基于 Flutter 最新稳定版本编写。如果遇到版本相关问题，请参考 [Flutter 官方安装指南](https://docs.flutter.dev/get-started/install)。

