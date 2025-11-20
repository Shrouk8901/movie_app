import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/constants.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/data/models/auth/user_data_response.dart';
import 'package:movies_app/data/models/user_profile/update_user_profile_request.dart';
import 'package:movies_app/data/models/user_profile/user_profile_response.dart';

class ProfileRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveDataWhenStatusError: true,
    ),
  );

  Future<UserProfileResponse> updateProfile(
    UpdateUserProfileRequest request,
    String token,
  ) async {
    try {
      final response = await _dio.patch(
        ApiConstants.profileEndPoint,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return UserProfileResponse.fromJson(response.data);
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
      throw APIException('Failed to Update Profile');
    }
  }

  Future<UserProfileResponse> deleteAccount(String token) async {
    try {
      final response = await _dio.delete(
        ApiConstants.profileEndPoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return UserProfileResponse.fromJson(response.data);
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
      throw APIException('Failed to Delete Account');
    }
  }

  Future<UserDataResponse> getProfile(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.profileEndPoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
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
      throw APIException('Failed to Get Account');
    }
  }
}
