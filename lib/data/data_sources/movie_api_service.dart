//
// import 'package:dio/dio.dart';
// import 'package:movies_app/core/constants/api_endpoints.dart';
// import 'package:movies_app/data/models/movies/movie_model.dart';
//
// import '../models/movies/movie_details_model.dart';
//
// class MovieApiService {
//   final Dio dio;
//
//   MovieApiService(this.dio);
//
//   Future<MovieDetailsResponse> getMovieDetails(
//     int movieId,
//     bool withImages,
//     bool withCast,
//   ) async {
//     try {
//       print('🌐 Making API call for movie ID: $movieId');
//
//       final response = await dio.get(
//         '${ApiEndpoints.baseUrl}${ApiEndpoints.movieDetails}',
//         queryParameters: {
//           'movie_id': movieId.toString(),
//           'with_images': withImages.toString().toLowerCase(),
//           'with_cast': withCast.toString().toLowerCase(),
//         },
//       );
//
//       print('📦 API Response keys: ${response.data.keys}');
//       print('📦 API Response: ${response.data}');
//
//       return MovieDetailsResponse.fromJson(response.data);
//     } catch (e) {
//       print('❌ API Error: $e');
//       throw Exception('Failed to load movie details: $e');
//     }
//   }
//
//   Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
//     try {
//       print('🌐 Making similar movies API call for movie ID: $movieId');
//
//       final response = await dio.get(
//         '${ApiEndpoints.baseUrl}${ApiEndpoints.movieSuggestions}',
//         queryParameters: {'movie_id': movieId.toString()},
//       );
//
//       print('📦 Similar Movies API Response: ${response.data}');
//
//       // Handle different response structures
//       if (response.data is Map<String, dynamic>) {
//         final data = response.data as Map<String, dynamic>;
//
//         // Check if response has status error
//         if (data['status'] == 'error') {
//           throw Exception(data['status_message'] ?? 'API error');
//         }
//
//         // Try different possible structures
//         if (data.containsKey('data') && data['data'] is Map) {
//           final dataMap = data['data'] as Map<String, dynamic>;
//           if (dataMap.containsKey('movies') && dataMap['movies'] is List) {
//             final moviesData = dataMap['movies'] as List;
//             return moviesData.map((json) => MovieModel.fromJson(json)).toList();
//           }
//         }
//
//         if (data.containsKey('movies') && data['movies'] is List) {
//           final moviesData = data['movies'] as List;
//           return moviesData.map((json) => MovieModel.fromJson(json)).toList();
//         }
//       }
//
//       // If it's a list directly
//       if (response.data is List) {
//         final data = response.data as List;
//         return data.map((json) => MovieModel.fromJson(json)).toList();
//       }
//
//       throw Exception('Unexpected API response format');
//     } catch (e) {
//       print('❌ Similar Movies API Error: $e');
//       throw Exception('Failed to load similar movies: $e');
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/api_endpoints.dart';
import 'package:movies_app/data/models/movies/movie_model.dart';

import '../models/movies/movie_details_model.dart';

class MovieApiService {
  final Dio dio;

  MovieApiService(this.dio);

  Future<MovieDetailsResponse> getMovieDetails(
    int movieId,
    bool withImages,
    bool withCast,
  ) async {
    try {

      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.movieDetails}',
        queryParameters: {
          'movie_id': movieId.toString(),
          'with_images': withImages.toString().toLowerCase(),
          'with_cast': withCast.toString().toLowerCase(),
        },
      );



      return MovieDetailsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    try {

      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.movieSuggestions}',
        queryParameters: {'movie_id': movieId.toString()},
      );


      // Handle different response structures
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        // Check if response has status error
        if (data['status'] == 'error') {
          throw Exception(data['status_message'] ?? 'API error');
        }

        // Try different possible structures
        if (data.containsKey('data') && data['data'] is Map) {
          final dataMap = data['data'] as Map<String, dynamic>;
          if (dataMap.containsKey('movies') && dataMap['movies'] is List) {
            final moviesData = dataMap['movies'] as List;
            return moviesData.map((json) => MovieModel.fromJson(json)).toList();
          }
        }

        if (data.containsKey('movies') && data['movies'] is List) {
          final moviesData = data['movies'] as List;
          return moviesData.map((json) => MovieModel.fromJson(json)).toList();
        }
      }

      // If it's a list directly
      if (response.data is List) {
        final data = response.data as List;
        return data.map((json) => MovieModel.fromJson(json)).toList();
      }

      throw Exception('Unexpected API response format');
    } catch (e) {
      throw Exception('Failed to load similar movies: $e');
    }
  }
}
