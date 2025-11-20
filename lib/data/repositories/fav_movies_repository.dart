import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/core/constants/errors/faliure.dart';
import 'package:movies_app/data/data_sources/local_data_sources/auth_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/data_sources/remote_data_sources/fav_movies_remote_data_source.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';

class FavMoviesRepository {
  final AuthSharedPrefLocalDataSources _authSharedPrefLocalDataSources =
      AuthSharedPrefLocalDataSources();
  final FavMoviesRemoteDataSource _favMoviesRemoteDataSource =
      FavMoviesRemoteDataSource();

  Future<Either<Failure, bool>> isFavMovie(String movieId) async {
    try {
      String token = await _authSharedPrefLocalDataSources.getToken();
      final response =
          await _favMoviesRemoteDataSource.isFavMovie(movieId, token);
      return Right(response.isFav);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }

  Future<Either<Failure, List<MovieBasicInfo>>> getAllFavMovies() async {
    try {
      String token = await _authSharedPrefLocalDataSources.getToken();
      final response = await _favMoviesRemoteDataSource.getAllFavMovies(token);
      return Right(response.data);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }

   Future<Either<Failure, String >> addToFavMovies(MovieBasicInfo movie) async {
    try {
      String token = await _authSharedPrefLocalDataSources.getToken();
     final response = await _favMoviesRemoteDataSource.addToFavMovies(token,movie);
      return Right(response.message);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }

   Future<Either<Failure, String >> removeFromFavMovies(String movieId) async {
    try {
      String token = await _authSharedPrefLocalDataSources.getToken();
     final removeMessage= await _favMoviesRemoteDataSource.removeFromFavMovies(token,movieId);
      return Right(removeMessage);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }
}
