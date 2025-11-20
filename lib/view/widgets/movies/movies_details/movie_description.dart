import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/data/models/movies/movie_model.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class MovieDescription extends StatelessWidget {
  final MovieModel movie;

  const MovieDescription({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final description = movie.descriptionFull ?? movie.summary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.description,
            style: AppStyles.bold24Roboto.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 10.h),
          if (description != null && description.isNotEmpty)
            Text(
              description,
              style: AppStyles.regular16gray.copyWith(color: AppColors.white),
              // textAlign: TextAlign.justify,
            )
          else
            Text(
              AppLocalizations.of(context)!.description_not_found,
              style: AppStyles.regular16Roboto.copyWith(color: AppColors.white),
            ),
        ],
      ),
    );
  }
}
