import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/api_endpoints.dart';
import 'package:movies_app/data/data_sources/local_data_sources/movies_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/models/movies/movies_model.dart';
import 'package:movies_app/data/models/movies/movie_model.dart';

class MoviesRepository {
  final Dio dio;
  final MoviesSharedPrefLocalDataSources localDataSource;

  MoviesRepository(this.dio, this.localDataSource);

  /// Cached Home Movies
  Future<List<MoviesModel>> getMoviesCashed({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cached = await localDataSource.getCachedMovies();
        if (cached.isNotEmpty) return cached;
      }

      final response = await dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.listMovies}",
      );

      final data = response.data["data"];
      final moviesJson = data?["movies"];
      if (moviesJson == null) return [];

      final movies = (moviesJson as List)
          .map((movie) => MoviesModel.fromJson(movie))
          .toList();

      await localDataSource.cacheMovies(movies);
      return movies;
    } catch (e) {
      throw Exception("Failed to load movies: $e");
    }
  }

  /// For general list
  Future<List<MoviesModel>> getMovies() async {
    try {
      final response = await dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.listMovies}",
      );

      final data = response.data["data"];
      final moviesJson = data?["movies"];
      if (moviesJson == null) return [];

      return (moviesJson as List)
          .map((movie) => MoviesModel.fromJson(movie))
          .toList();
    } catch (e) {
      throw Exception("Failed to load movies: $e");
    }
  }

  /// For search
  Future<List<MoviesModel>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.listMovies}",
        queryParameters: {
          if (query.isNotEmpty) "query_term": query,
        },
      );

      final data = response.data["data"];
      final moviesJson = data?["movies"];
      if (moviesJson == null) return [];

      return (moviesJson as List)
          .map((movie) => MoviesModel.fromJson(movie))
          .toList();
    } catch (e) {
      throw Exception("Failed to search movies: $e");
    }
  }

  /// Movie Details
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.movieDetails}",
        queryParameters: {
          "movie_id": movieId,
          "with_images": true,
          "with_cast": true,
        },
      );

      final data = response.data["data"]["movie"];
      return MovieModel.fromJson(data);
    } catch (e) {
      throw Exception("Failed to load movie details: $e");
    }
  }

  /// Similar Movies
  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    try {
      final response = await dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.movieSuggestions}",
        queryParameters: {
          "movie_id": movieId,
        },
      );

      final moviesJson = response.data["data"]["movies"];
      if (moviesJson == null) return [];

      return (moviesJson as List)
          .map((movie) => MovieModel.fromJson(movie))
          .toList();
    } catch (e) {
      throw Exception("Failed to load similar movies: $e");
    }
  }
}
