import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/data/models/movies/movies_model.dart';
import 'package:movies_app/data/models/categories/category_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد المكتبة
import 'package:movies_app/core/routes/app_routes.dart';
import 'package:movies_app/view/widgets/movies/custom_film_poster.dart';

import '../../../../../view_model/movies/movies_cubit.dart';
import '../../../../../view_model/movies/movies_states.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  final List<CategoryModel> categories = CategoryModel.categories;
  CategoryModel? _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MoviesCubit>()
          .fetchMoviesByGenre(_selectedCategory!.apiValue);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200.h) {
        context.read<MoviesCubit>().loadMoreMovies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildCategoriesBar(),
          _buildMoviesGrid(),
        ],
      ),
    );
  }

  Widget _buildCategoriesBar() {
    return Container(
      height: 60.h, // استخدام h
      padding: EdgeInsets.symmetric(vertical: 10.h), // استخدام h
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.name == _selectedCategory!.name;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w), // استخدام w
            child: Container(
              decoration: BoxDecoration(
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.yellowPrimaryColor),
                borderRadius: BorderRadius.circular(16.r), // استخدام r
              ),
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<MoviesCubit>()
                      .fetchMoviesByGenre(category.apiValue);
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppColors.yellowPrimaryColor
                      : AppColors.blackPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r), // استخدام r
                  ),
                ),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.blackPrimaryColor
                        : AppColors.yellowPrimaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoviesGrid() {
    return BlocBuilder<MoviesCubit, MoviesState>(
      builder: (context, state) {
        final moviesCubit = context.read<MoviesCubit>();
        final moviesList = moviesCubit.moviesByGenre;
        bool hasMore = false;

        if (state is MoviesLoaded) {
          hasMore = state.hasMore;
        }

        if (state is MoviesLoading && moviesList.isEmpty) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (moviesList.isNotEmpty ||
            (state is MoviesLoading && moviesList.isNotEmpty)) {
          return Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10.r), // استخدام r
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w, // استخدام w
                mainAxisSpacing: 10.h, // استخدام h
                childAspectRatio: 189 / 279,
              ),
              itemCount: moviesList.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == moviesList.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final MoviesModel movie = moviesList[index];
                return CustomFilmPoster(
                  imagePath: movie.poster,
                  rating: movie.rating.toStringAsFixed(1),
                  width: double.infinity, // استخدام w
                  height: double.infinity, // استخدام h
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.movieDetailsRoute,
                        arguments: movie.id);
                  },
                );
              },
            ),
          );
        } else if (state is MoviesError) {
          return Expanded(
            child: Center(
              child: Text('Error: ${state.message}'),
            ),
          );
        }
        return const Expanded(
          child: Center(
            child: Text('Select a category to browse movies.'),
          ),
        );
      },
    );
  }
}
