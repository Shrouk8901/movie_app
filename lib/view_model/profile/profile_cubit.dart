import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/models/auth/user_model.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';
import 'package:movies_app/data/models/user_profile/update_user_profile_request.dart';
import 'package:movies_app/data/repositories/fav_movies_repository.dart';
import 'package:movies_app/data/repositories/history_movies_repository.dart';
import 'package:movies_app/data/repositories/user_profile_repository.dart';
import 'package:movies_app/view_model/profile/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitial());

  final UserProfileRepository _repository = UserProfileRepository();
  final FavMoviesRepository _favMoviesRepository = FavMoviesRepository();
  final HistoryMoviesRepository _historyRepository = HistoryMoviesRepository();
  List<MovieBasicInfo> favMovies = [];
  List<MovieBasicInfo> historyMovies = [];
  UserModel? user;

  Future<void> updateProfile(UpdateUserProfileRequest request) async {
    emit(UpdateProfileLoading());

    final result = await _repository.updateProfile(request);
    result.fold((faliure) => emit(UpdateProfileError(faliure.errorMessage)),
        (message) async {
      String updateMessage = message;
      final userResult = await _repository.getProfile();
      userResult.fold(
          (faliure) => emit(UpdateProfileError(faliure.errorMessage)), (data) {
        user = data;
        emit(UpdateProfileSuccess(updateMessage));
      });
    });
  }

  Future<void> deleteProfile() async {
    emit(DeleteProfileLoading());
    final result = await _repository.deleteAccount();
    result.fold((faliure) => emit(DeleteProfileError(faliure.errorMessage)),
        (data) {
      user = null;
      emit(DeleteProfileSuccess(data));
    });
  }

  Future<void> getProfileWithMovies() async {

    final userResult = await _repository.getProfile();
    userResult.fold(
      (faliure) => emit(GetProfileError(faliure.errorMessage)),
      (data) {
        user = data;
        emit(GetProfileLoading());
      },
    );

    final recentMoviesResult = await _historyRepository.getRecentMovies();
    recentMoviesResult.fold(
      (faliure) => emit(GetProfileError(faliure.errorMessage)),
      (result) {
        historyMovies = result;
      },
    );

    final favMoviesResult = await _favMoviesRepository.getAllFavMovies();
    favMoviesResult.fold(
      (faliure) => emit(GetProfileError(faliure.errorMessage)),
      (result) {
        favMovies = result;
      },
    );

    emit(GetProfileSuccess());
  }

  Future<void> getProfile() async {
    emit(GetProfileLoading());
    final userResult = await _repository.getProfile();
    userResult.fold(
      (faliure) => emit(GetProfileError(faliure.errorMessage)),
      (data) {
        user = data;
        emit(GetProfileSuccess());
      },
    );
  }

  Future<void> getFavMovies() async {
    emit(GetFavMoviesLoading());
    final favMoviesResult = await _favMoviesRepository.getAllFavMovies();
    favMoviesResult.fold(
        (faliure) => emit(GetFavMoviesError(faliure.errorMessage)), (result) {
      emit(GetFavMoviesSuccess());
      favMovies = result;
    });
  }

  Future<void> addToRecentMovies(MovieBasicInfo movie) async {
    final recentMoviesResult =
        await _historyRepository.addToRecentMovies(movie);

    recentMoviesResult.fold(
      (failure) => {emit(RecentMoviesError(failure.errorMessage))},
      (result) async {
        emit(RecentMoviesLoading());
        final recentListResult = await _historyRepository.getRecentMovies();
        recentListResult
            .fold((failure) => emit(RecentMoviesError(failure.errorMessage)),
                (recentList) {
          historyMovies = recentList;
          emit(RecentMoviesSuccess());
        });
      },
    );
  }
}
