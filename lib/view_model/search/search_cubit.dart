import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/repositories/movies_repository.dart';
import 'search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final MoviesRepository repository;

  SearchCubit(this.repository) : super(SearchInitial()) {
    loadDefaultMovies();
  }

  Future<void> loadDefaultMovies() async {
    emit(SearchLoading());
    try {
      final movies = await repository.getMovies(); // ✅ returns List<MoviesModel>
      emit(SearchLoaded(movies));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      await loadDefaultMovies();
      return;
    }

    emit(SearchLoading());
    try {
      final movies = await repository.searchMovies(query); // ✅ use proper search
      emit(SearchLoaded(movies));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
