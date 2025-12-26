import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stockc/core/config/env_config.dart';
import 'app_exception.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio _dio;
  late EnvConfig _env;
  late StreamController<void> _unauthorizedController;
  CancelToken _cancelToken = CancelToken();

  // Expose unauthorized event
  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  DioClient._internal() {
    _unauthorizedController = StreamController<void>.broadcast();
    // Default to DEV if not initialized
    _env = EnvConfig.dev; // TODO:正式环境记着修改
    _initDio();
  }

  void init(EnvConfig env) {
    _env = env;
    _dio.options.baseUrl = env.baseUrl;
    _updateInterceptors();
  }

  // Dynamic header management
  void updateHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  // Token management
  String? _token;
  String? get token => _token;
  void setToken(String? token) {
    _token = token;
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _env.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _updateInterceptors();
  }

  void _updateInterceptors() {
    _dio.interceptors.clear();

    // 1. Auth Interceptor (Handles Token injection & 401)
    _dio.interceptors.add(AuthInterceptor(this));

    // 2. Log Interceptor
    if (_env.enableLog) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  // Called by Interceptor when 401 occurs
  void handleUnauthorized() {
    if (!_unauthorizedController.isClosed) {
      _unauthorizedController.add(null);
    }
    cancelAllRequests();
  }

  void cancelAllRequests() {
    _cancelToken.cancel('Unauthorized - Cancelling all requests');
    _cancelToken = CancelToken(); // Reset token
  }

  // Generic Method for all requests
  Future<T> request<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken ?? _cancelToken,
      );

      // 检查响应中的 code 字段（业务错误码）
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData != null && responseData.containsKey('code')) {
        final code = responseData['code'] as int?;
        if (code != null && code != 200) {
          // 业务错误，抛出 BusinessException
          final errorMsg =
              responseData['error_msg'] as String? ??
              responseData['message'] as String? ??
              'Business error';
          throw BusinessException(errorMsg, code);
        }
      }

      if (fromJson != null) {
        try {
          return fromJson(responseData?['data'] ?? responseData);
        } catch (e) {
          throw BusinessException('Serialization Error: $e', -1);
        }
      }
      return response.data as T;
    } catch (e) {
      throw AppException.create(e);
    }
  }

  // --- Convenience Methods ---

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  // --- Upload & Download ---

  Future<T> upload<T>(
    String path, {
    required List<String> filePaths,
    String fileKey = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
    ProgressCallback? onSendProgress,
  }) async {
    final formData = FormData.fromMap(data ?? {});

    for (var filePath in filePaths) {
      final file = await MultipartFile.fromFile(filePath);
      formData.files.add(MapEntry(fileKey, file));
    }

    return request<T>(
      path,
      method: 'POST',
      data: formData,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  Future<void> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw AppException.create(e);
    }
  }
}
