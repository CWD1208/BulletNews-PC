# Logo 设置说明

## 步骤

### 1. 准备 Logo 图片
- 准备一个 **1024x1024** 像素的 PNG 格式图片
- 图片应该是正方形，背景透明或白色
- 将图片命名为 `app_icon.png`

### 2. 放置 Logo 文件
将 `app_icon.png` 文件放到以下目录：
```
assets/icons/app_icon.png
```

### 3. 生成图标
运行以下命令生成 iOS 和 Android 的所有尺寸图标：

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### 4. 验证
- **Android**: 图标会生成到 `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **iOS**: 图标会生成到 `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### 5. 重新构建应用
```bash
flutter clean
flutter pub get
flutter run
```

## 配置说明

当前配置在 `pubspec.yaml` 中：
- `image_path`: 源图片路径
- `adaptive_icon_background`: Android 自适应图标背景色（白色）
- `adaptive_icon_foreground`: Android 自适应图标前景图
- `remove_alpha_ios`: iOS 移除透明通道

## 注意事项

1. 确保源图片是 1024x1024 像素
2. 图片应该是正方形
3. 建议使用 PNG 格式，支持透明背景
4. 生成后需要重新构建应用才能看到新图标

