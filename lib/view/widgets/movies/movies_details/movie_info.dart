import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/styles/app_assets.dart';
import '../../../../core/constants/styles/app_colors.dart';
import '../../../../core/constants/styles/app_styles.dart';
import '../../../../data/models/movies/movie_model.dart';

class MovieInfo extends StatelessWidget {
  final MovieModel movie;

  const MovieInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Info(image: AppAssets.favIcon, info: '15'),
          Info(image: AppAssets.timeIcon, info: '${movie.runtime}'),
          Info(
              image: AppAssets.rateIcon,
              info: movie.rating.toStringAsFixed(1)),
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key, required this.image, required this.info});

  final String image;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 122.w,
      height: 47.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadiusDirectional.circular(16.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            image,
            width: 28.w,
            height: 25.h,
            fit: BoxFit.scaleDown,
          ),
          // SizedBox(width: 14),
          Text(
            info,
            style: AppStyles.bold24Roboto.copyWith(fontSize: 24.sp),
          )
        ],
      ),
    );
  }
}
