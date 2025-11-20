import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/core/constants/errors/faliure.dart';
import 'package:movies_app/data/data_sources/local_data_sources/auth_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/data_sources/local_data_sources/user_existance_shared_pref_locale_source.dart';

class UserExistanceRepository {
  final UserExistanceSharedPrefLocaleSource _localeSource =
      UserExistanceSharedPrefLocaleSource();

  final AuthSharedPrefLocalDataSources _authSharedPrefLocalDataSources =
      AuthSharedPrefLocalDataSources();

  Future<Either<Failure, bool>> checkAlreadySeenOnboarding() async {
    try {
      final result = await _localeSource.checkAlreadySeenOnboarding();
      return Right(result);
    } on AppException catch (ex) {
      return Left(Failure(ex.toString()));
    }
  }

  Future<Either<Failure, void>> finishOnboarding() async {
    try {
      await _localeSource.finishOnboarding();
      return Right(null);
    } on AppException catch (ex) {
      return Left(Failure(ex.toString()));
    }
  }


  Future<Either<Failure, bool>> alreadyLogged() async {
    try {
      final result=await _authSharedPrefLocalDataSources.alreadyLogged();
      return Right(result);
    } on AppException catch (ex) {
      return Left(Failure(ex.toString()));
    }
  }
  
}
