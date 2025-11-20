import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout with server',
          statusCode: 408,
          errorCode: 'CONNECTION_TIMEOUT',
        );

      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout with server',
          statusCode: 408,
          errorCode: 'SEND_TIMEOUT',
        );

      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout with server',
          statusCode: 408,
          errorCode: 'RECEIVE_TIMEOUT',
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Bad certificate',
          statusCode: 495,
          errorCode: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(dioError);

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          statusCode: 499,
          errorCode: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection',
          statusCode: 503,
          errorCode: 'NO_INTERNET',
        );

      case DioExceptionType.unknown:
        return ApiException(
          message: 'Unknown error occurred',
          statusCode: 520,
          errorCode: 'UNKNOWN_ERROR',
        );
    }
  }

  static ApiException _handleResponseError(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    final errorData = dioError.response?.data;

    String message = 'Something went wrong';
    String errorCode = 'UNKNOWN_RESPONSE_ERROR';

    if (errorData is Map<String, dynamic>) {
      message = errorData['message'] ?? errorData['status_message'] ?? message;
      errorCode = errorData['error'] ?? errorData['status'] ?? errorCode;
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
      case 401:
        return ApiException(
          message: 'Unauthorized access',
          statusCode: statusCode,
          errorCode: 'UNAUTHORIZED',
        );
      case 403:
        return ApiException(
          message: 'Forbidden access',
          statusCode: statusCode,
          errorCode: 'FORBIDDEN',
        );
      case 404:
        return ApiException(
          message: 'Resource not found',
          statusCode: statusCode,
          errorCode: 'NOT_FOUND',
        );
      case 500:
        return ApiException(
          message: 'Internal server error',
          statusCode: statusCode,
          errorCode: 'INTERNAL_SERVER_ERROR',
        );
      case 503:
        return ApiException(
          message: 'Service unavailable',
          statusCode: statusCode,
          errorCode: 'SERVICE_UNAVAILABLE',
        );
      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
    }
  }

  @override
  String toString() =>
      'ApiException: $message (Code: $statusCode, Error: $errorCode)';
}
