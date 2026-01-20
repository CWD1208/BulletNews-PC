import 'package:flutter/material.dart';
import 'ext_colors.dart';

extension ThemeContext on BuildContext {
  /// Easy access to the ExtColors extension
  ExtColors get colors =>
      Theme.of(this).extension<ExtColors>() ?? ExtColors.light;

  /// Easy access to standard TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Easy access to standard ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// 自定义文本样式扩展
  ///
  /// 使用示例：
  /// ```dart
  /// Text('标题', style: context.textStyles.headingLarge)
  /// Text('正文', style: context.textStyles.bodyMedium)
  /// ```
  AppTextStyles get textStyles => AppTextStyles(this);
}

/// 自定义文本样式类
///
/// 根据字体规范：
/// - Rubik - Bold: 特殊字体、标题、弹窗标题
/// - Rubik - SemiBold: 副标题、用户card名称
/// - Rubik - Medium: 内容
/// - Sen - Regular: 时间、极少不是很重要的信息
///
/// 行高规则：Line-Height = Font-Size + 8px
class AppTextStyles {
  final BuildContext context;

  AppTextStyles(this.context);

  ExtColors get _colors =>
      Theme.of(context).extension<ExtColors>() ?? ExtColors.light;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  /// 获取文本主色（根据明暗模式自动选择）
  Color get _textPrimaryColor =>
      _isDark
          ? (_colors.textPrimaryDark ?? Colors.white)
          : (_colors.textPrimaryLight ?? const Color(0xFF333333));

  /// 获取文本辅助色（根据明暗模式自动选择）
  Color get _textSecondaryColor =>
      _isDark
          ? (_colors.textAuxiliaryDark ?? const Color(0x99FFFFFF))
          : (_colors.textAuxiliaryLight3 ?? const Color(0xFF999999));

  /// 计算行高：Font-Size + 8px
  double _lineHeight(double fontSize) => fontSize + 8;

  // ========== Rubik 字体样式 ==========

  /// Rubik Bold - 特殊字体、标题、弹窗标题
  TextStyle rubikBold({
    double fontSize = 24,
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
  }) => TextStyle(
    fontFamily: 'Rubik',
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    height: _lineHeight(fontSize) / fontSize, // 行高比例
    color: color ?? _textPrimaryColor,
  );

  /// Rubik SemiBold - 副标题、用户card名称
  TextStyle rubikSemiBold({double fontSize = 18, Color? color}) => TextStyle(
    fontFamily: 'Rubik',
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    height: _lineHeight(fontSize) / fontSize,
    color: color ?? _textPrimaryColor,
  );

  /// Rubik Medium - 内容
  TextStyle rubikMedium({double fontSize = 16, Color? color}) => TextStyle(
    fontFamily: 'Rubik',
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    height: _lineHeight(fontSize) / fontSize,
    color: color ?? _textPrimaryColor,
  );

  /// Rubik Regular - 常规文本
  TextStyle rubikRegular({double fontSize = 14, Color? color}) => TextStyle(
    fontFamily: 'Rubik',
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    height: _lineHeight(fontSize) / fontSize,
    color: color ?? _textPrimaryColor,
  );

  // ========== Sen 字体样式 ==========

  /// Sen Regular - 时间、极少不是很重要的信息
  TextStyle senRegular({double fontSize = 12, Color? color}) => TextStyle(
    fontFamily: 'Sen', // 如果未添加 Sen 字体，将回退到系统字体
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    height: _lineHeight(fontSize) / fontSize,
    color: color ?? _textSecondaryColor,
  );

  // ========== 常用样式快捷方式 ==========

  /// 标题样式（Rubik Bold）
  TextStyle get title => rubikBold(fontSize: 24);

  /// 副标题样式（Rubik SemiBold）
  TextStyle get subtitle => rubikSemiBold(fontSize: 18);

  /// 内容样式（Rubik Medium）
  TextStyle get content => rubikMedium(fontSize: 16);

  /// 正文样式（Rubik Regular）
  TextStyle get body => rubikRegular(fontSize: 14);

  /// 时间/次要信息样式（Sen Regular）
  TextStyle get time => senRegular(fontSize: 12);

  /// 按钮文本样式
  TextStyle get buttonText => rubikSemiBold(fontSize: 16, color: Colors.white);

  /// 输入框文本样式
  TextStyle get inputText => rubikRegular(
    fontSize: 14,
    color: _isDark ? _colors.textAuxiliaryDark : _colors.textInputLight,
  );

  /// 辅助文本样式（使用辅助色）
  TextStyle get auxiliaryText => rubikRegular(
    fontSize: 14,
    color: _isDark ? _colors.textAuxiliaryDark : _colors.textAuxiliaryLight3,
  );

  /// 强调文本样式（使用主色）
  TextStyle get accentText => rubikMedium(
    fontSize: 14,
    color: _colors.primaryColor ?? const Color(0xFF9556FF),
  );

  /// 成功文本样式（使用绿色）
  TextStyle get successText => rubikRegular(
    fontSize: 14,
    color: _colors.auxiliaryGreen ?? const Color(0xFF1BA725),
  );

  /// 错误文本样式（使用红色）
  TextStyle get errorText => rubikRegular(
    fontSize: 14,
    color: _colors.auxiliaryRed ?? const Color(0xFFF25C5C),
  );

  // ========== Splash 页面样式 ==========

  /// Splash 标题样式（Rubik Bold, 28px, 主色）
  TextStyle get splashTitle => rubikBold(
    fontSize: 28,
    color: _colors.primaryColor ?? const Color(0xFF9556FF),
  ).copyWith(height: 1.2);

  /// Splash 副标题样式（Rubik Medium, 16px, 辅助色）
  TextStyle get splashSubtitle => rubikMedium(
    fontSize: 16,
    color: _textSecondaryColor,
  ).copyWith(height: 1.2);

  /// Splash 按钮文本样式（Rubik SemiBold, 16px, 白色）
  TextStyle get splashButtonText =>
      rubikBold(fontSize: 18, color: Colors.white);

  /// Splash 按钮文本样式（Rubik Bold, 15px, 白色, 500）
  TextStyle get splashButtonTextSmall =>
      rubikBold(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500);

  // ========== AI 问题选项样式 ==========

  /// AI 选项文本样式（选中状态）- 14px, 700, 主色, 居中
  TextStyle get aiOptionTextSelected => rubikBold(
    fontSize: 14,
    color: _colors.primaryColor ?? const Color(0xFF9556FF),
  );

  /// AI 选项文本样式（未选中状态）- 14px, 500, 主文本色, 居中
  TextStyle get aiOptionTextUnselected =>
      rubikMedium(fontSize: 14, color: _textPrimaryColor);

  /// AI 欢迎信息样式
  TextStyle get aiWelcomeText => rubikBold(
    fontSize: 20,
    color: _colors.primaryColor ?? const Color(0xFF9556FF),
  );

  /// AI 问题文本样式
  TextStyle get aiQuestionText =>
      rubikBold(fontSize: 20, color: _textPrimaryColor);

  /// AI 按钮文本样式
  TextStyle get aiButtonText =>
      rubikSemiBold(fontSize: 16, color: Colors.white);

  /// AI 按钮文本样式（禁用状态）
  TextStyle get aiButtonTextDisabled => rubikSemiBold(
    fontSize: 16,
    color: _colors.textAuxiliaryLight3 ?? const Color(0xFF999999),
  );

  /// AI 进度指示器文本样式
  TextStyle get aiProgressText => rubikSemiBold(
    fontSize: 14,
    color: _colors.primaryColor ?? const Color(0xFF9556FF),
  );

  /// AI 话题文本样式
  TextStyle get aiTopicText =>
      rubikMedium(fontSize: 16, color: _colors.textPrimaryLight);

  // ========== 向后兼容的样式 ==========

  /// 标题样式（向后兼容）
  TextStyle get headingLarge => title;
  TextStyle get headingMedium => subtitle;
  TextStyle get headingSmall => rubikBold(fontSize: 20);

  /// 正文样式（向后兼容）
  TextStyle get bodyLarge => content;
  TextStyle get bodyMedium => body;
  TextStyle get bodySmall => rubikRegular(fontSize: 12);

  /// 次要文本样式（向后兼容）
  TextStyle get secondaryText => auxiliaryText;
}
