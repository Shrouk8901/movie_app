import 'package:dio/dio.dart';
import 'package:movies_app/data/data_sources/local_data_sources/movies_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/models/movies/movies_model.dart'; // list/search
import 'package:movies_app/data/models/movies/movie_model.dart'; // details

class MoviesRepository {
  final Dio dio;
  final MoviesSharedPrefLocalDataSources localDataSource;

  MoviesRepository(this.dio,this.localDataSource);

  Future<List<MoviesModel>> getMoviesCashed({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cached = await localDataSource.getCachedMovies();
        if (cached.isNotEmpty) return cached;
      }

      final response = await dio.get("https://yts.mx/api/v2/list_movies.json");

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


  /// For search & list
  Future<List<MoviesModel>> getMovies() async {
    try {
      final response = await dio.get(
        "https://yts.mx/api/v2/list_movies.json",
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

  /// For search with query
  Future<List<MoviesModel>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        "https://yts.mx/api/v2/list_movies.json",
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

  /// For details
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get(
        "https://yts.mx/api/v2/movie_details.json",
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

  /// For similar movies
  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    try {
      final response = await dio.get(
        "https://yts.mx/api/v2/movie_suggestions.json",
        queryParameters: {"movie_id": movieId},
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
