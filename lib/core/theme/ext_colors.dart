import 'package:flutter/material.dart';

@immutable
class ExtColors extends ThemeExtension<ExtColors> {
  // Background Colors
  final Color? globalBackground; // 全局背景色 #F5F6F8
  final Color? lightGray; // 浅灰 #F0F1F3
  final Color? gray; // 灰 #D0D2D5

  // Primary & Auxiliary Colors
  final Color? primaryColor; // 主色调 #9556FF (紫色)
  final Color? auxiliaryGreen; // 辅助色-绿色 #1BA725
  final Color? auxiliaryRed; // 辅助色-红色 #F25C5C

  // Semantic Function Colors (保持兼容性)
  final Color? functionSuccess;
  final Color? functionError;
  final Color? functionWarning;
  final Color? functionInfo;

  // Text Colors for Light Background
  final Color? textPrimaryLight; // 字体主色 #333333
  final Color? textAuxiliaryLight1; // 字体辅助 #00A780
  final Color? textAuxiliaryLight2; // 字体辅助 #666666
  final Color? textAuxiliaryLight3; // 字体辅助 #999999
  final Color? textInputLight; // 输入框字符 #BCBCBC

  // Text Colors for Dark Background
  final Color? textPrimaryDark; // 字体主色 #FFFFFF 100%
  final Color? textAuxiliaryDark; // 字体主色 #FFFFFF 60%

  // Legacy support (保持向后兼容)
  final Color? sidebarColor;
  final Color? incomingMessageBubbleColor;
  final Color? outgoingMessageBubbleColor;
  final Color? textPrimary;
  final Color? textSecondary;
  final Color? alwaysWhite;

  const ExtColors({
    this.globalBackground,
    this.lightGray,
    this.gray,
    this.primaryColor,
    this.auxiliaryGreen,
    this.auxiliaryRed,
    this.functionSuccess,
    this.functionError,
    this.functionWarning,
    this.functionInfo,
    this.textPrimaryLight,
    this.textAuxiliaryLight1,
    this.textAuxiliaryLight2,
    this.textAuxiliaryLight3,
    this.textInputLight,
    this.textPrimaryDark,
    this.textAuxiliaryDark,
    // Legacy support
    this.sidebarColor,
    this.incomingMessageBubbleColor,
    this.outgoingMessageBubbleColor,
    this.textPrimary,
    this.textSecondary,
    this.alwaysWhite,
  });

  @override
  ExtColors copyWith({
    Color? globalBackground,
    Color? lightGray,
    Color? gray,
    Color? primaryColor,
    Color? auxiliaryGreen,
    Color? auxiliaryRed,
    Color? functionSuccess,
    Color? functionError,
    Color? functionWarning,
    Color? functionInfo,
    Color? textPrimaryLight,
    Color? textAuxiliaryLight1,
    Color? textAuxiliaryLight2,
    Color? textAuxiliaryLight3,
    Color? textInputLight,
    Color? textPrimaryDark,
    Color? textAuxiliaryDark,
    // Legacy support
    Color? sidebarColor,
    Color? incomingMessageBubbleColor,
    Color? outgoingMessageBubbleColor,
    Color? textPrimary,
    Color? textSecondary,
    Color? alwaysWhite,
  }) {
    return ExtColors(
      globalBackground: globalBackground ?? this.globalBackground,
      lightGray: lightGray ?? this.lightGray,
      gray: gray ?? this.gray,
      primaryColor: primaryColor ?? this.primaryColor,
      auxiliaryGreen: auxiliaryGreen ?? this.auxiliaryGreen,
      auxiliaryRed: auxiliaryRed ?? this.auxiliaryRed,
      functionSuccess: functionSuccess ?? this.functionSuccess,
      functionError: functionError ?? this.functionError,
      functionWarning: functionWarning ?? this.functionWarning,
      functionInfo: functionInfo ?? this.functionInfo,
      textPrimaryLight: textPrimaryLight ?? this.textPrimaryLight,
      textAuxiliaryLight1: textAuxiliaryLight1 ?? this.textAuxiliaryLight1,
      textAuxiliaryLight2: textAuxiliaryLight2 ?? this.textAuxiliaryLight2,
      textAuxiliaryLight3: textAuxiliaryLight3 ?? this.textAuxiliaryLight3,
      textInputLight: textInputLight ?? this.textInputLight,
      textPrimaryDark: textPrimaryDark ?? this.textPrimaryDark,
      textAuxiliaryDark: textAuxiliaryDark ?? this.textAuxiliaryDark,
      // Legacy support
      sidebarColor: sidebarColor ?? this.sidebarColor,
      incomingMessageBubbleColor:
          incomingMessageBubbleColor ?? this.incomingMessageBubbleColor,
      outgoingMessageBubbleColor:
          outgoingMessageBubbleColor ?? this.outgoingMessageBubbleColor,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      alwaysWhite: alwaysWhite ?? this.alwaysWhite,
    );
  }

  @override
  ExtColors lerp(ThemeExtension<ExtColors>? other, double t) {
    if (other is! ExtColors) {
      return this;
    }
    return ExtColors(
      globalBackground: Color.lerp(globalBackground, other.globalBackground, t),
      lightGray: Color.lerp(lightGray, other.lightGray, t),
      gray: Color.lerp(gray, other.gray, t),
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      auxiliaryGreen: Color.lerp(auxiliaryGreen, other.auxiliaryGreen, t),
      auxiliaryRed: Color.lerp(auxiliaryRed, other.auxiliaryRed, t),
      functionSuccess: Color.lerp(functionSuccess, other.functionSuccess, t),
      functionError: Color.lerp(functionError, other.functionError, t),
      functionWarning: Color.lerp(functionWarning, other.functionWarning, t),
      functionInfo: Color.lerp(functionInfo, other.functionInfo, t),
      textPrimaryLight: Color.lerp(textPrimaryLight, other.textPrimaryLight, t),
      textAuxiliaryLight1: Color.lerp(
        textAuxiliaryLight1,
        other.textAuxiliaryLight1,
        t,
      ),
      textAuxiliaryLight2: Color.lerp(
        textAuxiliaryLight2,
        other.textAuxiliaryLight2,
        t,
      ),
      textAuxiliaryLight3: Color.lerp(
        textAuxiliaryLight3,
        other.textAuxiliaryLight3,
        t,
      ),
      textInputLight: Color.lerp(textInputLight, other.textInputLight, t),
      textPrimaryDark: Color.lerp(textPrimaryDark, other.textPrimaryDark, t),
      textAuxiliaryDark: Color.lerp(
        textAuxiliaryDark,
        other.textAuxiliaryDark,
        t,
      ),
      // Legacy support
      sidebarColor: Color.lerp(sidebarColor, other.sidebarColor, t),
      incomingMessageBubbleColor: Color.lerp(
        incomingMessageBubbleColor,
        other.incomingMessageBubbleColor,
        t,
      ),
      outgoingMessageBubbleColor: Color.lerp(
        outgoingMessageBubbleColor,
        other.outgoingMessageBubbleColor,
        t,
      ),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      alwaysWhite: Color.lerp(alwaysWhite, other.alwaysWhite, t),
    );
  }

  // --- Factory Methods for Light/Dark Themes ---
  // You can paste your massive color lists here or map them from your existing AppColors classes

  static const light = ExtColors(
    // Background Colors
    globalBackground: Color(0xFFF5F6F8), // 全局背景色
    lightGray: Color(0xFFF0F1F3), // 浅灰
    gray: Color(0xFFD0D2D5), // 灰
    // Primary & Auxiliary Colors
    primaryColor: Color(0xFF9556FF), // 主色调-紫色
    auxiliaryGreen: Color(0xFF1BA725), // 辅助色-绿色
    auxiliaryRed: Color(0xFFF25C5C), // 辅助色-红色
    // Semantic Function Colors (使用辅助色)
    functionSuccess: Color(0xFF1BA725), // 使用绿色
    functionError: Color(0xFFF25C5C), // 使用红色
    functionWarning: Color(0xFFf0a615),
    functionInfo: Color(0xFF9556FF), // 使用主色调
    // Text Colors for Light Background
    textPrimaryLight: Color(0xFF333333), // 字体主色
    textAuxiliaryLight1: Color(0xFF00A780), // 字体辅助
    textAuxiliaryLight2: Color(0xFF666666), // 字体辅助
    textAuxiliaryLight3: Color(0xFF999999), // 字体辅助
    textInputLight: Color(0xFFBCBCBC), // 输入框字符
    // Text Colors for Dark Background (占位，暗色模式时使用)
    textPrimaryDark: Color(0xFFFFFFFF), // 字体主色 100%
    textAuxiliaryDark: Color(0x99FFFFFF), // 字体主色 60% (0x99 = 153/255 ≈ 60%)
    // Legacy support
    sidebarColor: Color(0xFFF5F6F8),
    textPrimary: Color(0xFF333333),
    textSecondary: Color(0xFF999999),
    alwaysWhite: Color(0xFFFFFFFF),
  );

  static const dark = ExtColors(
    // Background Colors (暗色模式使用深色背景)
    globalBackground: Color(0xFF1A1A1A),
    lightGray: Color(0xFF2A2A2A),
    gray: Color(0xFF3A3A3A),
    // Primary & Auxiliary Colors (保持相同)
    primaryColor: Color(0xFF9556FF),
    auxiliaryGreen: Color(0xFF1BA725),
    auxiliaryRed: Color(0xFFF25C5C),
    // Semantic Function Colors
    functionSuccess: Color(0xFF1BA725),
    functionError: Color(0xFFF25C5C),
    functionWarning: Color(0xFFf0a615),
    functionInfo: Color(0xFF9556FF),
    // Text Colors for Dark Background
    textPrimaryDark: Color(0xFFFFFFFF), // 字体主色 100%
    textAuxiliaryDark: Color(0x99FFFFFF), // 字体主色 60%
    // Text Colors for Light Background (占位)
    textPrimaryLight: Color(0xFF333333),
    textAuxiliaryLight1: Color(0xFF00A780),
    textAuxiliaryLight2: Color(0xFF666666),
    textAuxiliaryLight3: Color(0xFF999999),
    textInputLight: Color(0xFFBCBCBC),
    // Legacy support
    sidebarColor: Color(0xFF1A1A1A),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0x99FFFFFF),
  );
}
