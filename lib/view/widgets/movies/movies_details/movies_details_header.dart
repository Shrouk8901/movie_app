import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/utils/ui_utils.dart';
import 'package:movies_app/data/models/movies/movie_basic_info.dart';
import 'package:movies_app/view_model/movies/fav_movies_cubit.dart';
import 'package:movies_app/view_model/movies/fav_movies_states.dart';
import 'package:movies_app/view_model/profile/profile_cubit.dart';
import '../../../../core/constants/styles/app_assets.dart';
import '../../../../core/constants/styles/app_colors.dart';
import '../../../../core/constants/styles/app_styles.dart';
import '../../../../data/models/movies/movie_model.dart';

class MoviesDetailsHeader extends StatefulWidget {
  final MovieModel movie;

  const MoviesDetailsHeader({super.key, required this.movie});

  @override
  State<MoviesDetailsHeader> createState() => _MoviesDetailsHeaderState();
}

class _MoviesDetailsHeaderState extends State<MoviesDetailsHeader> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<FavMoviesCubit>(context)
          .isFavMovie(widget.movie.id.toString());
    });

    super.initState();
  }

  bool? isFav;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final imageUrl = widget.movie.largeCoverImage ??
        widget.movie.mediumCoverImage ??
        widget.movie.backgroundImage;

    return Stack(
      children: [
        Container(
          height: screenSize.height * .70,
          width: double.infinity,
          decoration: BoxDecoration(
            image: imageUrl != null
                ? DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(imageUrl),
                  )
                : null,
            color: AppColors.grey,
          ),
          child: imageUrl == null
              ? const Icon(Icons.movie, size: 100, color: Colors.white54)
              : null,
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                AppColors.blackPrimaryColor.withValues(alpha: .9),
                AppColors.blackPrimaryColor.withValues(alpha: 0.7),
                Colors.transparent,
                AppColors.blackPrimaryColor.withValues(alpha: 0.7),
                AppColors.blackPrimaryColor,
              ],
              stops: [0.0, 0.1, 0.5, 0.7, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
        ),
        Positioned(
          top: 35.h,
          left: 16.w,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Directionality(
              textDirection: TextDirection.ltr,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
            iconSize: 35,
            padding: EdgeInsets.zero,
          ),
        ),
        Positioned(
          top: 33.h,
          right: 8.w,
          child: BlocConsumer<FavMoviesCubit, FavMoviesStates>(
            listener: (context, state) {
              if (state is FavMoviesError) {
                UIUtils.showMessage(state.message, context, AppColors.red);
              }
              if (state is AddMovieToFavLoading ||
                  state is RemoveFromFavLoading) {
                UIUtils.showLoading(context);
              } else if (state is AddMovieToFavError) {
                UIUtils.hideLoading(context);
                UIUtils.showMessage(state.errorMessage, context, AppColors.red);
              } else if (state is RemoveFromFavError) {
                UIUtils.hideLoading(context);
                UIUtils.showMessage(state.errorMessage, context, AppColors.red);
              } else if (state is AddMovieToFavSuccess) {
                UIUtils.hideLoading(context);
                UIUtils.showMessage(state.successMessage, context,
                    AppColors.yellowPrimaryColor);
                context.read<ProfileCubit>().getFavMovies();
              } else if (state is RemoveFromFavSuccess) {
                UIUtils.hideLoading(context);
                UIUtils.showMessage(state.successMessage, context,
                    AppColors.yellowPrimaryColor);
                context.read<ProfileCubit>().getFavMovies();
              }
            },
            builder: (context, state) {
              if (state is IsFavMovieSuccess) {
                isFav = state.isFav;
              } else if (state is AddMovieToFavSuccess) {
                log('message');
                isFav = true;
              } else if (state is RemoveFromFavSuccess) {
                isFav = false;
              }
              if (isFav == null) return const SizedBox.shrink();

              return IconButton(
                onPressed: () {
                  if (isFav!) {
                    context
                        .read<FavMoviesCubit>()
                        .removeFromFavMovies(widget.movie.id.toString());
                  } else {
                    context.read<FavMoviesCubit>().addToFavMovies(
                        MovieBasicInfo(
                            movieId: widget.movie.id.toString(),
                            name: widget.movie.title,
                            rating: widget.movie.rating,
                            imageUrl: widget.movie.largeCoverImage!,
                            year: widget.movie.year.toString()));
                  }
                },
                icon: Icon(
                  isFav! ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 38,
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          top: 250.h,
          child: SizedBox(
            child: Column(
              children: [
                SvgPicture.asset(AppAssets.watchIcon),
                Spacer(),
                Text(
                  widget.movie.titleLong ?? widget.movie.title,
                  style:
                      AppStyles.bold24Roboto.copyWith(color: AppColors.white),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),
                Text(
                  widget.movie.year.toString(),
                  style:
                      AppStyles.bold20Roboto.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
