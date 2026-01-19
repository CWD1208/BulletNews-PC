import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 通用工具类
class CommonUtil {
  /// 邮箱正则表达式
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// 验证是否是邮箱
  ///
  /// [email] 待验证的邮箱字符串
  /// 返回 true 如果是有效邮箱，否则返回 false
  static bool isEmail(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }
    return _emailRegex.hasMatch(email.trim());
  }

  /// 获取屏幕宽度
  ///
  /// [context] BuildContext
  /// 返回屏幕宽度（像素）
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// 获取屏幕高度
  ///
  /// [context] BuildContext
  /// 返回屏幕高度（像素）
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// 获取屏幕尺寸
  ///
  /// [context] BuildContext
  /// 返回 Size 对象，包含 width 和 height
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// 打开URL
  ///
  /// [url] 要打开的URL字符串
  /// [launchMode] 启动模式，默认为 LaunchMode.platformDefault
  ///   - LaunchMode.platformDefault: 使用平台默认方式
  ///   - LaunchMode.inAppWebView: 在应用内WebView打开
  ///   - LaunchMode.externalApplication: 在外部应用打开（跳出app）
  ///   - LaunchMode.externalNonBrowserApplication: 在外部非浏览器应用打开
  /// [webViewConfiguration] WebView配置（仅在LaunchMode.inAppWebView时有效）
  ///
  /// 返回 Future<bool>，true表示成功打开，false表示失败
  static Future<bool> openUrl(
    String url, {
    LaunchMode launchMode = LaunchMode.platformDefault,
    WebViewConfiguration? webViewConfiguration,
  }) async {
    try {
      // if (!await canLaunchUrl(Uri.parse(url))) {
      //   return false;
      // }
      return await launchUrl(
        Uri.parse(url),
        mode: launchMode,
        webViewConfiguration: webViewConfiguration ?? WebViewConfiguration(),
      );
    } catch (e) {
      return false;
    }
  }

  /// 打开URL（在外部浏览器打开，跳出app）
  ///
  /// [url] 要打开的URL字符串
  /// 返回 Future<bool>，true表示成功打开，false表示失败
  static Future<bool> launchUrlExternal(String url) {
    return openUrl(url, launchMode: LaunchMode.externalApplication);
  }

  /// 打开URL（在应用内WebView打开，不跳出app）
  ///
  /// [url] 要打开的URL字符串
  /// [webViewConfiguration] WebView配置
  /// 返回 Future<bool>，true表示成功打开，false表示失败
  static Future<bool> openUrlInApp(
    String url, {
    WebViewConfiguration? webViewConfiguration,
  }) {
    return openUrl(
      url,
      launchMode: LaunchMode.inAppWebView,
      webViewConfiguration: webViewConfiguration,
    );
  }

  /// 格式化时间
  ///
  /// [dateTime] DateTime 对象
  /// [format] 格式化字符串，默认为 'yyyy-MM-dd HH:mm:ss'
  ///   常用格式：
  ///   - 'yyyy-MM-dd': 2024-01-01
  ///   - 'yyyy-MM-dd HH:mm:ss': 2024-01-01 12:00:00
  ///   - 'MM/dd/yyyy': 01/01/2024
  ///   - 'HH:mm': 12:00
  ///   - 'yyyy年MM月dd日': 2024年01月01日
  ///
  /// 返回格式化后的时间字符串，如果 dateTime 为 null 则返回空字符串
  static String formatDateTime(
    DateTime? dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    if (dateTime == null) {
      return '';
    }

    // 简单的格式化实现，如果需要更复杂的格式化，可以使用 intl 包
    String formatted = format;

    // 年份
    formatted = formatted.replaceAll(
      'yyyy',
      dateTime.year.toString().padLeft(4, '0'),
    );
    formatted = formatted.replaceAll(
      'yy',
      dateTime.year.toString().substring(2),
    );

    // 月份
    formatted = formatted.replaceAll(
      'MM',
      dateTime.month.toString().padLeft(2, '0'),
    );
    formatted = formatted.replaceAll('M', dateTime.month.toString());

    // 日期
    formatted = formatted.replaceAll(
      'dd',
      dateTime.day.toString().padLeft(2, '0'),
    );
    formatted = formatted.replaceAll('d', dateTime.day.toString());

    // 小时
    formatted = formatted.replaceAll(
      'HH',
      dateTime.hour.toString().padLeft(2, '0'),
    );
    formatted = formatted.replaceAll('H', dateTime.hour.toString());
    formatted = formatted.replaceAll(
      'hh',
      (dateTime.hour % 12).toString().padLeft(2, '0'),
    );
    formatted = formatted.replaceAll('h', (dateTime.hour % 12).toString());

    // 分钟
    formatted = formatted.replaceAll(
      'mm',
      dateTime.minute.toString().padLeft(2, '0'),
    );
    formatted = formatted.replaceAll('m', dateTime.minute.toString());

    // 秒
    formatted = formatted.replaceAll(
      'ss',
      dateTime.second.toString().padLeft(2, '0'),
    );
    formatted = formatted.replaceAll('s', dateTime.second.toString());

    return formatted;
  }

  /// 格式化时间（使用 intl 包，更强大的格式化能力）
  ///
  /// [dateTime] DateTime 对象
  /// [format] 格式化字符串，默认为 'yyyy-MM-dd HH:mm:ss'
  ///
  /// 返回格式化后的时间字符串，如果 dateTime 为 null 则返回空字符串
  static String formatDateTimeWithIntl(
    DateTime? dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    if (dateTime == null) {
      return '';
    }
    try {
      // 注意：需要确保项目中已导入 intl 包
      // import 'package:intl/intl.dart';
      // 这里使用动态导入或者直接使用 DateUtil
      // 为了简化，这里提供一个基础实现
      // 如果需要完整功能，建议使用 DateUtil.formatDate
      return formatDateTime(dateTime, format: format);
    } catch (e) {
      return '';
    }
  }

  /// 格式化相对时间（如：刚刚、1分钟前、1小时前等）
  ///
  /// [dateTime] DateTime 对象
  /// [context] BuildContext，用于多语言支持（可选）
  /// 返回相对时间字符串
  static String formatRelativeTime(
    DateTime? dateTime, {
    BuildContext? context,
  }) {
    if (dateTime == null) {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      final template =
          context != null
              ? 'common_time_years_ago'.tr(context: context)
              : 'common_time_years_ago'.tr();
      return template.replaceAll('{count}', years.toString());
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      final template =
          context != null
              ? 'common_time_months_ago'.tr(context: context)
              : 'common_time_months_ago'.tr();
      return template.replaceAll('{count}', months.toString());
    } else if (difference.inDays > 0) {
      final template =
          context != null
              ? 'common_time_days_ago'.tr(context: context)
              : 'common_time_days_ago'.tr();
      return template.replaceAll('{count}', difference.inDays.toString());
    } else if (difference.inHours > 0) {
      final template =
          context != null
              ? 'common_time_hours_ago'.tr(context: context)
              : 'common_time_hours_ago'.tr();
      return template.replaceAll('{count}', difference.inHours.toString());
    } else if (difference.inMinutes > 0) {
      final template =
          context != null
              ? 'common_time_minutes_ago'.tr(context: context)
              : 'common_time_minutes_ago'.tr();
      return template.replaceAll('{count}', difference.inMinutes.toString());
    } else {
      return context != null
          ? 'common_time_just_now'.tr(context: context)
          : 'common_time_just_now'.tr();
    }
  }
}
