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
        ApiEndpoints.baseUrl + ApiEndpoints.movieDetails,
        queryParameters: {
          'movie_id': movieId,
          'with_images': withImages.toString().toLowerCase(),
          'with_cast': withCast.toString().toLowerCase(),
        },
      );

      return MovieDetailsResponse.fromJson(response.data);
    } catch (e) {
      print("❌ DETAILS ERROR: $e");
      throw Exception('Failed to load movie details: $e');
    }
  }

  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.movieSuggestions,
        queryParameters: {
          'movie_id': movieId,
        },
      );

      // Basic structure validation
      if (response.data['status'] != 'ok') {
        final msg = response.data['status_message'] ?? "Failed to load suggestions";
        throw Exception(msg);
      }

      final moviesJson = response.data['data']['movies'] as List? ?? [];
      return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ SUGGESTIONS ERROR: $e");
      throw Exception('Failed to load similar movies: $e');
    }
  }
}
