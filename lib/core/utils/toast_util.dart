import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Toast 类型枚举（兼容旧代码）
enum ToastType { success, error, normal }

/// 全局 Toast 管理器（使用 toastification 包）
/// 注意：需要在 MaterialApp 的 builder 中使用 ToastificationWrapper
class Toast {
  /// 显示 Toast
  static void show(
    String message, {
    ToastType type = ToastType.normal,
    Duration duration = const Duration(seconds: 1),
  }) {
    ToastificationType toastType;
    switch (type) {
      case ToastType.success:
        toastType = ToastificationType.success;
        break;
      case ToastType.error:
        toastType = ToastificationType.error;
        break;
      case ToastType.normal:
        toastType = ToastificationType.info;
        break;
    }

    toastification.show(
      type: toastType,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      showProgressBar: false,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  /// 显示成功 Toast
  static void success(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    show(message, type: ToastType.success, duration: duration);
  }

  /// 显示错误 Toast
  static void error(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    show(message, type: ToastType.error, duration: duration);
  }

  /// 显示普通 Toast
  static void normal(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    show(message, type: ToastType.normal, duration: duration);
  }

  /// 清除所有 Toast
  static void clear() {
    toastification.dismissAll();
  }
}
