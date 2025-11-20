import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/styles/app_assets.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view/screens/movie_details/movie_details_page.dart';
import 'package:movies_app/view/widgets/movies/custom_film_poster.dart';
import 'package:movies_app/view_model/search/search_cubit.dart';
import 'package:movies_app/view_model/search/search_states.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: 0.95.sw,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: TextField(
              style: TextStyle(color: AppColors.white),
              onChanged: (value) {
                context.read<SearchCubit>().searchMovies(value);
              },
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Image.asset(
                    AppAssets.searchIcon,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                hintText: AppLocalizations.of(context)!.search,
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: AppColors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchStates>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  if (state.movies.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_movies_found,
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.all(8.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 191 / 279,
                    ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return CustomFilmPoster(
                        imagePath: movie.poster,
                        rating: (movie.rating).toString(),
                        height: double.infinity,
                        width: double.infinity,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MovieDetailsPage(movieId: movie.id),
                              ));
                        },
                      );
                    },
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }
}
