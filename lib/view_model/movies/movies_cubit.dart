import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/data_sources/local_data_sources/movies_shared_pref_local_data_sources.dart';
import 'package:movies_app/data/data_sources/remote_data_sources/movies_remote_data_source.dart';
import 'package:movies_app/data/models/movies/movies_model.dart';
import 'movies_states.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final MoviesRemoteDataSource dataSource;
  final MoviesSharedPrefLocalDataSources localDataSource;
  List<MoviesModel> _allMovies = [];
  final Map<String, List<MoviesModel>> _moviesByGenre = {};
  int _currentPage = 1;
  String _currentGenre = '';
  bool _hasMore = true;

  MoviesCubit(this.dataSource,this.localDataSource) : super(MoviesInitial());

 Future<void> fetchMovies({bool forceRefresh = false}) async {
    emit(MoviesLoading());
    try {
      if (!forceRefresh) {
        final cached = await localDataSource.getCachedMovies();
        if (cached.isNotEmpty) {
          _allMovies = cached;
          emit(MoviesLoaded(
            movies: List.from(_allMovies),
            moviesByGenre: _moviesByGenre[_currentGenre]?.toList() ?? [],
            hasMore: _hasMore,
          ));
          return;
        }
      }
      _allMovies = await dataSource.fetchMovies(forceRefresh: true);
      _allMovies.shuffle();
      await localDataSource.cacheMovies(_allMovies); 

      emit(MoviesLoaded(
        movies: List.from(_allMovies),
        moviesByGenre: _moviesByGenre[_currentGenre]?.toList() ?? [],
        hasMore: _hasMore,
      ));
    } catch (e) {
      emit(MoviesError("Failed to fetch movies: $e"));
    }
  }
  // دالة جديدة لبدء التصفح أو تغيير النوع
  Future<void> fetchMoviesByGenre(String genre) async {
    _currentGenre = genre;
    _currentPage = 1;
    _hasMore = true;
    _moviesByGenre[genre] = [];
    emit(MoviesLoading());
    await _fetchNextPage();
  }
  Future<void> refreshMovies() async {
    try {
      emit(MoviesLoading());
      _allMovies = await dataSource.fetchMovies(forceRefresh: true);
      _allMovies.shuffle();
      await localDataSource.cacheMovies(_allMovies);
      if (_currentGenre.isNotEmpty) {
        _moviesByGenre[_currentGenre] = [];
        _currentPage = 1;
        _hasMore = true;
        await _fetchNextPage();
      } else {
        emit(MoviesLoaded(
          movies: List.from(_allMovies),
          moviesByGenre: _moviesByGenre[_currentGenre]?.toList() ?? [],
        ));
      }
    } catch (e) {
      emit(MoviesError("Failed to refresh movies: $e"));
    }
    print('MoviesCubit: Movies refreshed successfully');
  }
  // دالة لتحميل الصفحة التالية من الأفلام
  Future<void> _fetchNextPage() async {
    if (!_hasMore) return;
    try {
      final newMovies = await dataSource.fetchMovies(genre: _currentGenre, page: _currentPage, forceRefresh: true);

      // خطوة 1: التحقق من أن القائمة الجديدة ليست فارغة
      if (newMovies.isEmpty) {
        _hasMore = false;
        emit(MoviesLoaded(
          movies: _allMovies,
          moviesByGenre: _moviesByGenre[_currentGenre]!,
          hasMore: _hasMore,
        ));
        return; // توقف العملية
      }

      // خطوة 2: تصفية الأفلام الجديدة لإزالة أي أفلام مكررة
      final existingMoviesIds = <int>{};
      for (var movie in _moviesByGenre[_currentGenre]!) {
        existingMoviesIds.add(movie.id);
      }
      final uniqueNewMovies = newMovies.where((movie) => !existingMoviesIds.contains(movie.id)).toList();

      // خطوة 3: إذا لم يتم العثور على أفلام فريدة، فهذا يعني أن القائمة تتكرر
      if(uniqueNewMovies.isEmpty) {
        _hasMore = false;
      } else {
        _moviesByGenre[_currentGenre]!.addAll(uniqueNewMovies);
        _currentPage++;
      }

      emit(MoviesLoaded(
        movies: _allMovies,
        moviesByGenre: _moviesByGenre[_currentGenre]!,
        hasMore: _hasMore,
      ));
    } catch (e) {
      _hasMore = false;
      emit(MoviesError(e.toString()));
    }
  }

  void loadMoreMovies() {
    if (state is MoviesLoading) return;
    _fetchNextPage();
  }

  // getters لتسهيل الوصول إلى البيانات
  List<MoviesModel> get moviesByGenre => _moviesByGenre[_currentGenre] ?? [];
  bool get hasMore => _hasMore;
}