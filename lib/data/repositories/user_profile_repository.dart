import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/core/constants/errors/faliure.dart';
import 'package:movies_app/data/data_sources/local_data_sources/auth_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/data_sources/local_data_sources/movies_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/data_sources/remote_data_sources/profile_remote_data_source.dart';
import 'package:movies_app/data/models/auth/user_model.dart';
import 'package:movies_app/data/models/user_profile/update_user_profile_request.dart';

class UserProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource =
      ProfileRemoteDataSource();

  final AuthSharedPrefLocalDataSources _authSharedPrefLocalDataSources =
      AuthSharedPrefLocalDataSources();

  final MoviesSharedPrefLocalDataSources _moviesSharedPrefLocalDataSources =
      MoviesSharedPrefLocalDataSources();

  Future<Either<Failure, String>> updateProfile(
    UpdateUserProfileRequest request,
  ) async {
    try {
      String token = await _authSharedPrefLocalDataSources.getToken();
      final response =
          await _profileRemoteDataSource.updateProfile(request, token);
      return Right(response.message);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }

  Future<Either<Failure, String>> deleteAccount() async {
    try {
      String token = await _authSharedPrefLocalDataSources.getToken();
      final response = await _profileRemoteDataSource.deleteAccount(token);
      await _authSharedPrefLocalDataSources.deleteUserLoggedState();
      await _moviesSharedPrefLocalDataSources.clearRecentMovies();
      return Right(response.message);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }

  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      String token = await _authSharedPrefLocalDataSources.getToken();
      final response = await _profileRemoteDataSource.getProfile(token);
      return Right(response.userModel);
    } on AppException catch (exception) {
      return Left(Failure(exception.message));
    }
  }
}
