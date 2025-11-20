import 'package:movies_app/data/models/movies/movies_model.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<MoviesModel> movies;
  final List<MoviesModel> moviesByGenre;
  final bool hasMore;

  MoviesLoaded({
    this.movies = const [],
    this.moviesByGenre = const [],
    this.hasMore = false,
  });
}

class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}