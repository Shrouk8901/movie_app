import 'package:movies_app/data/models/movies/movies_model.dart';

abstract class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchLoaded extends SearchStates {
  final List<MoviesModel> movies;
  SearchLoaded(this.movies);
}

class SearchError extends SearchStates {
  final String message;
  SearchError(this.message);
}
