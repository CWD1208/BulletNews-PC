import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => '$message${code != null ? ' ($code)' : ''}';

  static AppException create(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException('Connection timed out');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final data = error.response?.data;

          if (statusCode == 401) {
            return UnauthorizedException('Unauthorized access');
          }
          if (statusCode == 403) {
            return ForbiddenException('Access forbidden');
          }
          if (statusCode != null && statusCode >= 500) {
            return ServerException('Server error', statusCode);
          }
          // Try to parse business error message from server response if structure is known
          // e.g. { "message": "error msg", "code": 1001 }
          String msg = 'Unknown error';
          if (data is Map && data['message'] != null) {
            msg = data['message'].toString(); // Safely cast to String
          } else if (error.message != null) {
            msg = error.message!;
          }
          return BusinessException(msg, statusCode);

        case DioExceptionType.cancel:
          return CancelException('Request canceled');
        case DioExceptionType.connectionError:
          return ConnectivityException('No internet connection');
        default:
          return NetworkException('Network error: ${error.message}');
      }
    } else if (error is AppException) {
      return error; // Already parsed
    } else {
      return UnknownException(error.toString());
    }
  }
}

class NetworkException extends AppException {
  NetworkException(super.message, [super.code]);
}

class ConnectivityException extends AppException {
  ConnectivityException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends AppException {
  ForbiddenException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message, [super.code]);
}

class BusinessException extends AppException {
  BusinessException(super.message, [super.code]);
}

class CancelException extends AppException {
  CancelException(super.message);
}

class UnknownException extends AppException {
  UnknownException(super.message);
}
