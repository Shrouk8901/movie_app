//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:movies_app/core/network/api_exceptions.dart';
// import 'package:movies_app/data/models/movies/movie_model.dart';
//
// import '../../data/repositories/movie_repository_impl.dart';
//
// part 'movie_details_state.dart';
//
// class MovieDetailsCubit extends Cubit<MovieDetailsStates> {
//   final MovieRepositoryImpl movieRepository;
//
//   MovieDetailsCubit({required this.movieRepository})
//       : super(MovieDetailsInitialState());
//
//   Future<void> getMovieDetails(int movieId) async {
//     try {
//       emit(MovieDetailsLoadingState());
//
//       if (movieId == null) {
//         throw ApiException(
//           message: 'Movie ID is required',
//           statusCode: 400,
//           errorCode: 'MISSING_MOVIE_ID',
//         );
//       }
//
//       final movie = await movieRepository.getMovieDetails(movieId);
//
//       try {
//         final similarMovies = await movieRepository.getSimilarMovies(movieId);
//         emit(MovieDetailsSuccessState(
//           movie: movie,
//           similarMovies: similarMovies,
//         ));
//       } on ApiException catch (e) {
//         print(
//             '⚠️ Partial success: Failed to load similar movies: ${e.message}');
//         emit(MovieDetailsPartialSuccessState(
//           movie: movie,
//           errorMessage: e.message,
//         ));
//       }
//     } on ApiException catch (e) {
//       final isNetworkError =
//           e.statusCode == 503 || e.errorCode == 'NETWORK_ERROR';
//
//       print('❌ Movie details error: ${e.message}');
//
//       emit(MovieDetailsErrorState(
//         errorMessage: e.message,
//         statusCode: e.statusCode,
//         errorCode: e.errorCode,
//         isNetworkError: isNetworkError,
//       ));
//     } catch (e) {
//       print('❌ Unexpected error: $e');
//       emit(MovieDetailsErrorState(
//         errorMessage: 'An unexpected error occurred: $e',
//       ));
//     }
//   }
//
//   Future<void> retryLoadingSimilarMovies(int movieId) async {
//     try {
//       if (movieId == null) return;
//
//       final similarMovies = await movieRepository.getSimilarMovies(movieId);
//
//       if (state is MovieDetailsPartialSuccessState) {
//         final currentState = state as MovieDetailsPartialSuccessState;
//         emit(MovieDetailsSuccessState(
//           movie: currentState.movie,
//           similarMovies: similarMovies,
//         ));
//       } else if (state is MovieDetailsSuccessState) {
//         final currentState = state as MovieDetailsSuccessState;
//         emit(MovieDetailsSuccessState(
//           movie: currentState.movie,
//           similarMovies: similarMovies,
//         ));
//       }
//     } on ApiException catch (e) {
//       print('❌ Failed to retry loading similar movies: ${e.message}');
//     } catch (e) {
//       print('❌ Unexpected error during retry: $e');
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/errors/api_exceptions.dart';
import 'package:movies_app/data/models/movies/movie_model.dart';
import 'package:movies_app/data/repositories/movies_repository.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsStates> {
  final MoviesRepository movieRepository;

  MovieDetailsCubit({required this.movieRepository})
      : super(MovieDetailsInitialState());

  Future<void> getMovieDetails(int movieId) async {
    try {
      emit(MovieDetailsLoadingState());
      final movie = await movieRepository.getMovieDetails(movieId);
      try {
        final similarMovies = await movieRepository.getSimilarMovies(movieId);
        emit(MovieDetailsSuccessState(
          movie: movie,
          similarMovies: similarMovies,
        ));
      } on ApiException catch (e) {
        emit(MovieDetailsPartialSuccessState(
          movie: movie,
          errorMessage: e.message,
        ));
      }
    } on ApiException catch (e) {
      final isNetworkError =
          e.statusCode == 503 || e.errorCode == 'NETWORK_ERROR';

      emit(MovieDetailsErrorState(
        errorMessage: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
        isNetworkError: isNetworkError,
      ));
    } catch (e) {
      emit(MovieDetailsErrorState(
        errorMessage: 'An unexpected error occurred: $e',
      ));
    }
  }

  Future<void> retryLoadingSimilarMovies(int movieId) async {
    try {
      final similarMovies = await movieRepository.getSimilarMovies(movieId);

      if (state is MovieDetailsPartialSuccessState) {
        final currentState = state as MovieDetailsPartialSuccessState;
        emit(MovieDetailsSuccessState(
          movie: currentState.movie,
          similarMovies: similarMovies,
        ));
      } else if (state is MovieDetailsSuccessState) {
        final currentState = state as MovieDetailsSuccessState;
        emit(MovieDetailsSuccessState(
          movie: currentState.movie,
          similarMovies: similarMovies,
        ));
      }
    } on ApiException catch (e) {
      print('❌ Failed to retry loading similar movies: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error during retry: $e');
    }
  }
}
