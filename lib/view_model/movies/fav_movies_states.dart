abstract class FavMoviesStates {}

class FavMoviesInitial extends FavMoviesStates {}


class FavMoviesError extends FavMoviesStates {
  final String message;
  FavMoviesError(this.message);
}

class IsFavMovieSuccess extends FavMoviesStates {
  final bool isFav;
  IsFavMovieSuccess(this.isFav);
}

class AddMovieToFavLoading extends FavMoviesStates {}

class AddMovieToFavSuccess extends FavMoviesStates {
  final String successMessage;

  AddMovieToFavSuccess(this.successMessage);
}

class AddMovieToFavError extends FavMoviesStates {
  final String errorMessage;

  AddMovieToFavError(this.errorMessage);
}

class RemoveFromFavLoading extends FavMoviesStates {}

class RemoveFromFavSuccess extends FavMoviesStates {
  final String successMessage;

  RemoveFromFavSuccess(this.successMessage);
}

class RemoveFromFavError extends FavMoviesStates {
  final String errorMessage;

  RemoveFromFavError(this.errorMessage);
}
