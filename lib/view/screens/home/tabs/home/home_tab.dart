import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // إضافة المكتبة
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/data/models/categories/category_model.dart';
import 'package:movies_app/data/models/movies/movies_model.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view_model/movies/movies_cubit.dart';
import 'package:movies_app/view_model/movies/movies_states.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../widgets/movies/custom_film_poster.dart';

class HomeTab extends StatefulWidget {
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategoryChanged;

  const HomeTab({
    super.key,
    required this.selectedCategoryIndex,
    required this.onCategoryChanged,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  late String _currentGenre;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _currentGenre =
        CategoryModel.categories[widget.selectedCategoryIndex].apiValue;
    _loadInitialData();
  }

  void _loadInitialData() {
    final cubit = context.read<MoviesCubit>();
    if (cubit.state is! MoviesLoaded ||
        (cubit.state as MoviesLoaded).movies.isEmpty) {
      cubit.fetchMovies();
    }
    cubit.fetchMoviesByGenre(_currentGenre);
  }

  @override
  void didUpdateWidget(HomeTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedCategoryIndex != widget.selectedCategoryIndex) {
      final newGenre =
          CategoryModel.categories[widget.selectedCategoryIndex].apiValue;
      if (_currentGenre != newGenre) {
        _currentGenre = newGenre;
        context.read<MoviesCubit>().fetchMoviesByGenre(newGenre);
      }
    }
  }

  void _navigateToMovieDetails(MoviesModel movie) {
    Navigator.pushNamed(
      context,
      AppRoutes.movieDetailsRoute,
      arguments: movie.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: BlocConsumer<MoviesCubit, MoviesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MoviesError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is MoviesLoaded) {
            final movies = state.movies;
            final genreMovies = state.moviesByGenre;

            return Stack(
              children: [
                Positioned.fill(
                  child: movies.isNotEmpty
                      ? Image.network(
                          movies[currentIndex].poster,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: .6),
                          Colors.black,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        Center(
                          child: Image.asset("assets/images/available_now.png"),
                        ),
                        SizedBox(height: 20.h),
                        if (movies.isNotEmpty)
                          CarouselSlider(
                            items: movies.map((movie) {
                              return CustomFilmPoster(
                                imagePath: movie.poster,
                                rating: (movie.rating).toString(),
                                height: 350.h,
                                width: 250.w,
                                onTap: () => _navigateToMovieDetails(movie),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 350.h,
                              enlargeCenterPage: true,
                              viewportFraction: 0.5,
                              enableInfiniteScroll: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.scale,
                              scrollPhysics: const BouncingScrollPhysics(),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                        SizedBox(height: 30.h),
                        Image.asset("assets/images/watch_now.png"),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                CategoryModel
                                    .categories[widget.selectedCategoryIndex]
                                    .name,
                                style: AppStyles.regular16white,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.see_more,
                                      style: AppStyles.regular16white.copyWith(
                                        color: AppColors.yellowPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(Icons.arrow_forward,
                                        color: AppColors.yellowPrimaryColor,
                                        size: 20.sp),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 280.h,
                          child: genreMovies.isNotEmpty
                              ? ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  itemCount: genreMovies.length,
                                  itemBuilder: (context, index) {
                                    final genreMovie = genreMovies[index];
                                    return CustomFilmPoster(
                                      imagePath: genreMovie.poster,
                                      rating: (genreMovie.rating).toString(),
                                      height: 220.h,
                                      width: 150.w,
                                      onTap: () =>
                                          _navigateToMovieDetails(genreMovie),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 10.w),
                                )
                              : Center(
                                  child: Text(
                                    "No movies found for this category",
                                    style: AppStyles.regular16white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
