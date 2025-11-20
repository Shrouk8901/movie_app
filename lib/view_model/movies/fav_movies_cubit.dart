import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';
import 'package:movies_app/data/repositories/fav_movies_repository.dart';
import 'package:movies_app/view_model/movies/fav_movies_states.dart';

class FavMoviesCubit extends Cubit<FavMoviesStates> {
  FavMoviesCubit() : super(FavMoviesInitial());

  final FavMoviesRepository _favMoviesRepository = FavMoviesRepository();

  Future<void> isFavMovie(String movieId) async {
    final result = await _favMoviesRepository.isFavMovie(movieId);
    result.fold((faliure) => emit(FavMoviesError(faliure.errorMessage)),
        (result) => emit(IsFavMovieSuccess(result)));
  }

  Future<void> addToFavMovies(MovieBasicInfo movie) async {
    emit(AddMovieToFavLoading());
    final result = await _favMoviesRepository.addToFavMovies(movie);
    result.fold((faliure) => emit(AddMovieToFavError(faliure.errorMessage)),
        (result) => emit(AddMovieToFavSuccess(result)));
  }

  Future<void> removeFromFavMovies(String movieId) async {
    emit(RemoveFromFavLoading());
    final result = await _favMoviesRepository.removeFromFavMovies(movieId);
    result.fold((faliure) => emit(RemoveFromFavError(faliure.errorMessage)),
        (result) => emit(RemoveFromFavSuccess(result)));
  }
}
