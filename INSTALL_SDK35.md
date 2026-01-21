# 安装 Android SDK 35 指南

## 方法一：通过 Android Studio（推荐）

1. 打开 Android Studio
2. 进入 SDK Manager：
   - macOS: `Android Studio` → `Settings` (或 `Preferences`) 
   - 选择 `Appearance & Behavior` → `System Settings` → `Android SDK`
   - 或直接点击工具栏的 SDK Manager 图标
3. 在 `SDK Platforms` 标签页：
   - 勾选 `Android 15.0 (API 35)` 或 `Android API 35`
   - 点击 `Apply` 开始安装
4. 等待安装完成

## 方法二：使用命令行工具

如果已安装 Android SDK 命令行工具，可以使用以下命令：

```bash
# 设置 SDK 路径（根据你的 local.properties）
export ANDROID_HOME=/Users/mac/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# 安装 Android SDK Platform 35
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platforms;android-35"

# 安装对应的 Build Tools
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "build-tools;35.0.0"
```

## 方法三：使用 Flutter 命令

Flutter 也可以帮助你安装所需的 SDK：

```bash
flutter doctor --android-licenses
flutter doctor -v
```

然后根据提示安装缺失的组件。

## 验证安装

安装完成后，可以通过以下方式验证：

```bash
# 检查已安装的 SDK 版本
ls /Users/mac/Library/Android/sdk/platforms

# 或者使用 Flutter 命令
flutter doctor -v
```

## 注意事项

- 安装 SDK 35 需要足够的磁盘空间（通常需要几百 MB 到几 GB）
- 确保网络连接正常，因为需要从 Google 服务器下载
- 如果在中国大陆，可能需要配置代理或使用镜像源

## 如果不想安装 SDK 35

如果你不想安装 SDK 35，可以考虑：

1. **降级插件版本**：检查 `appsflyer_sdk` 是否有不要求 SDK 35 的旧版本
2. **使用替代方案**：如果可能，使用其他不需要 SDK 35 的插件
3. **强制使用 SDK 34**：在 `build.gradle.kts` 中强制所有项目使用 SDK 34（但这可能导致某些功能不正常）

## 检查当前安装的 SDK 版本

运行以下命令查看已安装的版本：

```bash
ls /Users/mac/Library/Android/sdk/platforms
```
