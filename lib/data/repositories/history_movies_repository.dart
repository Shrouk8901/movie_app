import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/core/constants/errors/faliure.dart';
import 'package:movies_app/data/data_sources/local_data_sources/movies_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';

class HistoryMoviesRepository {
  MoviesSharedPrefLocalDataSources moviesSharedPrefLocalDataSources =
      MoviesSharedPrefLocalDataSources();

  Future<Either<Failure, List<MovieBasicInfo>>> getRecentMovies() async {
    try {
      final recentMovies =
          await moviesSharedPrefLocalDataSources.getRecentMovies();
      return Right(recentMovies);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }

   Future<Either<Failure, void>> addToRecentMovies(MovieBasicInfo movie) async {
    try {
          await moviesSharedPrefLocalDataSources.addToRecentMovies(movie);

      return Right(null);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }
}
