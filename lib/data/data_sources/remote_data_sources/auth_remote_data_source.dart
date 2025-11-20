import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/constants.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/data/models/auth/login_request.dart';
import 'package:movies_app/data/models/auth/login_response.dart';
import 'package:movies_app/data/models/auth/register_request.dart';
import 'package:movies_app/data/models/auth/user_data_response.dart';
import 'package:movies_app/data/models/auth/reset_password_request.dart';
import 'package:movies_app/data/models/auth/reset_password_response.dart';

class AuthRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveDataWhenStatusError: true,
    ),
  );

  Future<UserDataResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: request.toJson(),
      );
      return UserDataResponse.fromJson(response.data);
    } on DioException catch (exception) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          throw APIException('Connection timeout');
        case DioExceptionType.receiveTimeout:
          throw APIException('Receive timeout');
        case DioExceptionType.badResponse:
          throw APIException(
              'Bad response: ${exception.response?.statusCode}\n${exception.response?.data['message']}');
        case DioExceptionType.connectionError:
          throw APIException('Connection error: ${exception.message}');
        case DioExceptionType.cancel:
          throw APIException('Request was canceled');
        case DioExceptionType.unknown:
          throw APIException('Unexpected error: ${exception.message}');
        case DioExceptionType.sendTimeout:
          throw APIException('Send Timeout');
        case DioExceptionType.badCertificate:
          throw APIException('Bad Certificate');
      }
    } catch (exception) {
      throw APIException('Failed to Register');
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (exception) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          throw APIException('Connection timeout');
        case DioExceptionType.receiveTimeout:
          throw APIException('Receive timeout');
        case DioExceptionType.badResponse:
          throw APIException(
              'Bad response: ${exception.response?.statusCode}\n${exception.response?.data['message']}');
        case DioExceptionType.connectionError:
          throw APIException('Connection error: ${exception.message}');
        case DioExceptionType.cancel:
          throw APIException('Request was canceled');
        case DioExceptionType.unknown:
          throw APIException('Unexpected error: ${exception.message}');
        case DioExceptionType.sendTimeout:
          throw APIException('Send Timeout');
        case DioExceptionType.badCertificate:
          throw APIException('Bad Certificate');
      }
    } catch (exception) {
      throw APIException('Failed to Login');
    }
  }

  Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest request, String token) async {
    try {
      final response = await _dio.patch(
        ApiConstants.resetPasswordEndPoint,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return ResetPasswordResponse.fromJson(response.data);
    } on DioException catch (exception) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          throw APIException('Connection timeout');
        case DioExceptionType.receiveTimeout:
          throw APIException('Receive timeout');
        case DioExceptionType.badResponse:
          throw APIException(
              'Bad response: ${exception.response?.statusCode}\n${exception.response?.data['message']}');
        case DioExceptionType.connectionError:
          throw APIException('Connection error: ${exception.message}');
        case DioExceptionType.cancel:
          throw APIException('Request was canceled');
        case DioExceptionType.unknown:
          throw APIException('Unexpected error: ${exception.message}');
        case DioExceptionType.sendTimeout:
          throw APIException('Send Timeout');
        case DioExceptionType.badCertificate:
          throw APIException('Bad Certificate');
      }
    } catch (exception) {
      throw APIException('Failed to Reset Password');
    }
  }
}
