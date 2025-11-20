import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/core/constants/errors/faliure.dart';
import 'package:movies_app/data/data_sources/local_data_sources/localization_shared_pref_local_data_source.dart';

class LocalizationRepository {
  final LocalizationSharedPrefLocalDataSource _localDataSource =
      LocalizationSharedPrefLocalDataSource();

  Future<Either<Failure, String>> getLocale() async {
    try {
      String language = await _localDataSource.getLocale();
      return Right(language);
    } on AppException catch (ex) {
      return Left(Failure(ex.toString()));
    }
  }

  Future<Either<Failure, void>> setLocale(String language) async {
    try {
      await _localDataSource.setLocale(language);
      return Right(null);
    } on AppException catch (ex) {
      return Left(Failure(ex.toString()));
    }
  }
}
