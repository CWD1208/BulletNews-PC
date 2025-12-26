import 'package:flutter/material.dart';
import 'ext_colors.dart';

class AppTheme {
  /// 计算行高：Font-Size + 8px
  static double _lineHeight(double fontSize) => fontSize + 8;

  /// 构建 TextTheme（根据字体规范）
  ///
  /// 字体规范：
  /// - Rubik - Bold: 特殊字体、标题、弹窗标题
  /// - Rubik - SemiBold: 副标题、用户card名称
  /// - Rubik - Medium: 内容
  /// - Sen - Regular: 时间、极少不是很重要的信息
  ///
  /// 行高规则：Line-Height = Font-Size + 8px
  static TextTheme _buildTextTheme(
    Color textPrimaryColor,
    Color textSecondaryColor,
  ) {
    return TextTheme(
      // Display styles - 使用 Rubik Bold
      displayLarge: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: _lineHeight(57) / 57,
        color: textPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: _lineHeight(45) / 45,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: _lineHeight(36) / 36,
        color: textPrimaryColor,
      ),
      // Headline styles - 使用 Rubik Bold（标题、弹窗标题）
      headlineLarge: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: _lineHeight(32) / 32,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: _lineHeight(28) / 28,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: _lineHeight(24) / 24,
        color: textPrimaryColor,
      ),
      // Title styles - 使用 Rubik SemiBold（副标题、用户card名称）
      titleLarge: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: _lineHeight(22) / 22,
        color: textPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: _lineHeight(18) / 18,
        color: textPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: _lineHeight(16) / 16,
        color: textPrimaryColor,
      ),
      // Body styles - 使用 Rubik Medium（内容）
      bodyLarge: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: _lineHeight(16) / 16,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: _lineHeight(14) / 14,
        color: textPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: _lineHeight(12) / 12,
        color: textSecondaryColor,
      ),
      // Label styles - 使用 Sen Regular（时间、极少不是很重要的信息）
      labelLarge: TextStyle(
        fontFamily: 'Sen', // 如果未添加 Sen 字体，将回退到系统字体
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: _lineHeight(14) / 14,
        color: textSecondaryColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Sen',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: _lineHeight(12) / 12,
        color: textSecondaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Sen',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: _lineHeight(11) / 11,
        color: textSecondaryColor,
      ),
    );
  }

  // Standard Material 3 Light Theme
  static ThemeData get lightTheme {
    const ext = ExtColors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Map custom primary color to Material ColorScheme
      colorScheme: ColorScheme.light(
        primary: ext.primaryColor ?? const Color(0xFF9556FF),
        surface: ext.globalBackground ?? Colors.white,
        error: ext.auxiliaryRed ?? Colors.red,
        onSurface: ext.textPrimaryLight ?? const Color(0xFF333333),
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: ext.globalBackground ?? const Color(0xFFF5F6F8),

      // TextTheme - 使用设计规范的字体和行高
      textTheme: _buildTextTheme(
        ext.textPrimaryLight ?? const Color(0xFF333333),
        ext.textAuxiliaryLight3 ?? const Color(0xFF999999),
      ),

      // Register the extension
      extensions: [ext],
    );
  }

  // Standard Material 3 Dark Theme
  static ThemeData get darkTheme {
    const ext = ExtColors.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: ext.primaryColor ?? const Color(0xFF9556FF),
        surface: ext.globalBackground ?? Colors.black,
        error: ext.auxiliaryRed ?? Colors.red,
        onSurface: ext.textPrimaryDark ?? Colors.white,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: ext.globalBackground ?? const Color(0xFF1A1A1A),

      // TextTheme - 使用设计规范的字体和行高
      textTheme: _buildTextTheme(
        ext.textPrimaryDark ?? Colors.white,
        ext.textAuxiliaryDark ?? const Color(0x99FFFFFF),
      ),

      extensions: [ext],
    );
  }
}
