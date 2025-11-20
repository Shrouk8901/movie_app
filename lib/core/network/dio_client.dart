import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';
import '../constants/errors/api_exceptions.dart';

class DioClient {
  final Dio dio;

  DioClient({required this.dio}) {
    
    dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    );

    
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));

    
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        final apiException = ApiException.fromDioError(error);
        return handler.reject(apiException as DioException);
      },
    ));
  }

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on ApiException {
      rethrow; 
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Unknown error: $e');
    }
  }
}
