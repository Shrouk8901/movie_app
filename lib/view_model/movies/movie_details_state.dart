// part of 'movie_details_cubit.dart';
//
// abstract class MovieDetailsStates {}
//
// class MovieDetailsInitialState extends MovieDetailsStates {}
//
// class MovieDetailsLoadingState extends MovieDetailsStates {}
//
// class MovieDetailsSuccessState extends MovieDetailsStates {
//   final MovieModel movie;
//   final List<MovieModel> similarMovies;
//
//   MovieDetailsSuccessState({
//     required this.movie,
//     required this.similarMovies,
//   });
// }
//
// class MovieDetailsErrorState extends MovieDetailsStates {
//   final String errorMessage;
//   final int? statusCode;
//   final String? errorCode;
//   final bool isNetworkError;
//
//   MovieDetailsErrorState({
//     required this.errorMessage,
//     this.statusCode,
//     this.errorCode,
//     this.isNetworkError = false,
//   });
// }
//
// class MovieDetailsPartialSuccessState extends MovieDetailsStates {
//   final MovieModel movie;
//   final String errorMessage;
//
//   MovieDetailsPartialSuccessState({
//     required this.movie,
//     required this.errorMessage,
//   });
// }
part of 'movie_details_cubit.dart';

abstract class MovieDetailsStates {}

class MovieDetailsInitialState extends MovieDetailsStates {}

class MovieDetailsLoadingState extends MovieDetailsStates {}

class MovieDetailsSuccessState extends MovieDetailsStates {
  final MovieModel movie;
  final List<MovieModel> similarMovies;

  MovieDetailsSuccessState({
    required this.movie,
    required this.similarMovies,
  });
}

class MovieDetailsErrorState extends MovieDetailsStates {
  final String errorMessage;
  final int? statusCode;
  final String? errorCode;
  final bool isNetworkError;

  MovieDetailsErrorState({
    required this.errorMessage,
    this.statusCode,
    this.errorCode,
    this.isNetworkError = false,
  });
}

class MovieDetailsPartialSuccessState extends MovieDetailsStates {
  final MovieModel movie;
  final String errorMessage;

  MovieDetailsPartialSuccessState({
    required this.movie,
    required this.errorMessage,
  });
}
