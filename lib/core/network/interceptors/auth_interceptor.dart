import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/core/constants/api_endpoints.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/core/utils/logger.dart';

class AuthInterceptor extends Interceptor {
  final DioClient _client;
  final StorageService _storage = StorageService();

  AuthInterceptor(this._client);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加通用请求头
    _addCommonHeaders(options);

    // Check if path requires token
    final isNoToken = ApiEndpoints.noTokenEndpoints.any(
      (path) => options.path.contains(path),
    );

    if (!isNoToken) {
      final token = _client.token;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  /// 添加通用请求头
  void _addCommonHeaders(RequestOptions options) {
    // 1. app-version: 1.0.0
    options.headers['app-version'] = '1.0.0';

    // 2. device-type: android 或 ios
    if (Platform.isAndroid) {
      options.headers['device-type'] = 'android';
    } else if (Platform.isIOS) {
      options.headers['device-type'] = 'ios';
    } else {
      // 其他平台（web、desktop等）默认为 android
      options.headers['device-type'] = 'android';
    }

    // 3. language: 优先使用设置的语言，否则使用系统语言，如果系统语言不是英文或中文，默认使用英文
    final language = _getLanguage();
    options.headers['language'] = language;
  }

  /// 获取语言代码
  String _getLanguage() {
    // 1. 优先使用设置的语言
    final savedLanguageCode = _storage.getString('selected_language');
    if (savedLanguageCode != null && savedLanguageCode.isNotEmpty) {
      // 确保是支持的语言（en 或 zh）
      if (savedLanguageCode == 'en' || savedLanguageCode == 'zh') {
        return savedLanguageCode;
      }
    }

    // 2. 使用系统语言
    try {
      final systemLocale = ui.PlatformDispatcher.instance.locale;
      final systemLanguageCode = systemLocale.languageCode.toLowerCase();
      // 检查是否是英文或中文
      if (systemLanguageCode == 'en' || systemLanguageCode == 'zh') {
        return systemLanguageCode;
      }
    } catch (e) {
      // 如果获取系统语言失败，继续使用默认值
      LogUtils.w('Failed to get system locale: $e');
    }

    // 3. 默认使用英文
    return 'en';
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      LogUtils.w('401 Unauthorized detected. Triggering handling...');
      _client.handleUnauthorized();
    }

    // Pass to next which will be caught by DioClient's try-catch block wrapping request
    // However, since we are using interceptors, the error propogates back to the caller.
    return handler.next(err);
  }
}
