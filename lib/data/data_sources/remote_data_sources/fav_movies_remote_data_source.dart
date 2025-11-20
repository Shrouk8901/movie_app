import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/constants.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/data/models/movies/add_fav_response.dart';
import 'package:movies_app/data/models/movies/fav_movies_list_response.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';
import 'package:movies_app/data/models/movies/is_fav_movie_response.dart';

class FavMoviesRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveDataWhenStatusError: true,
    ),
  );

  Future<IsFavMovieResponse> isFavMovie(String movieId, String token) async {
    try {
      final response =
          await _dio.get('${ApiConstants.isMovieFavEndPoint}/$movieId',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ));
      final isFavMovieResponse = IsFavMovieResponse.fromJson(response.data);
      if (isFavMovieResponse.message !=
          'Favourite status fetched successfully') {
        throw Exception();
      }
      return isFavMovieResponse;
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
      throw APIException('Failed to Check Is Movie Fav');
    }
  }

  Future<FavMoviesListResponse> getAllFavMovies(String token) async {
    try {
      final response = await _dio.get(ApiConstants.getAllFavMoviesEndPoint,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      final favMoviesListResponse =
          FavMoviesListResponse.fromJson(response.data);
      if (favMoviesListResponse.message != 'favourites fetched successfully') {
        throw Exception();
      }
      return favMoviesListResponse;
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
      throw APIException('Failed to get fav Movies');
    }
  }

  Future<AddFavResponse> addToFavMovies(
      String token, MovieBasicInfo movie) async {
    try {
      final response = await _dio.post(
        ApiConstants.addToFavMoviesEndPoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: movie.toJson(),
      );
      final addFavResponse = AddFavResponse.fromJson(response.data);
      if (addFavResponse.message != 'Added to favourite successfully') {
        throw Exception();
      }
      return addFavResponse;
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
      throw APIException('Failed to add Movie to fav');
    }
  }

  Future<String> removeFromFavMovies(String token, String movieId) async {
    try {
      final response = await _dio.delete(
          '${ApiConstants.removeFromFavMoviesEndPoint}/$movieId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      final removeMessage = response.data['message'];
      if (removeMessage != 'Removed from favourite successfully') {
        throw Exception();
      }
      return removeMessage;
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
      throw APIException('Failed to remove Movie from fav');
    }
  }
}
