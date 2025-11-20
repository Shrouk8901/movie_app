import 'dart:convert';
import 'package:movies_app/core/constants/constants.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';
import 'package:movies_app/data/models/movies/movies_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesSharedPrefLocalDataSources {

  Future<void> cacheMovies(List<MoviesModel> movies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonMovies = movies.map((m) => m.toJson()).toList();
      await prefs.setString(Constants.cacheKey, jsonEncode(jsonMovies));
    } catch (e) {
      throw APIException("Failed to cache movies: $e");
    }
  }

  Future<List<MoviesModel>> getCachedMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(Constants.cacheKey);

      if (jsonString == null) return [];

      final List decoded = jsonDecode(jsonString);
      return decoded
          .map((m) => MoviesModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw APIException("Failed to load cached movies: $e");
    }
  }


  Future<void> addToRecentMovies(MovieBasicInfo movie) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedRecentMovies = prefs.getString(Constants.recentKey);
      List movies =
          cachedRecentMovies != null ? jsonDecode(cachedRecentMovies) : [];
      movies.removeWhere(
          (m) => MovieBasicInfo.fromJson(m).movieId == movie.movieId);

      movies.insert(0, movie.toJson());

      if (movies.length > 21) movies = movies.sublist(0, 21);

      await prefs.setString(Constants.recentKey, jsonEncode(movies));
    } catch (e) {
      throw SharedPrefException("Failed to cache recent movie: $e");
    }
  }

  Future<List<MovieBasicInfo>> getRecentMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedRecentMovies = prefs.getString(Constants.recentKey);

      if (cachedRecentMovies == null) return <MovieBasicInfo>[];
      final recentMoviesList = jsonDecode(cachedRecentMovies) as List;

      List<MovieBasicInfo> movies = [];
      for (var item in recentMoviesList) {
        try {
          final movie = MovieBasicInfo.fromJson(item as Map<String, dynamic>);
          movies.add(movie);
        } catch (e) {
          throw SharedPrefException(' Failed to parse movie: $e');
        }
      }
      return movies;
    } catch (e) {
      throw SharedPrefException("Failed to load recent movies: $e");
    }
  }

  Future<void> clearRecentMovies() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.recentKey);
  } catch (e) {
    throw SharedPrefException("Failed to clear recent movies: $e");
  }
}

}
