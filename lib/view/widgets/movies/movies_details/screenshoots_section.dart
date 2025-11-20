import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/data/models/movies/movie_model.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/view/widgets/movies/movies_details/screen_shot_item.dart';

class ScreenshotsSection extends StatelessWidget {
  final MovieModel movie;

  const ScreenshotsSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final hasScreenshots =
        movie.screenshots != null && movie.screenshots!.isNotEmpty;

    List<String> screenshotsToShow = [];

    if (hasScreenshots) {
      screenshotsToShow = movie.screenshots!.take(4).toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.screen_shots,
            style: AppStyles.bold24Roboto.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 11.h),
          Visibility(
            visible: hasScreenshots,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: screenshotsToShow.length,
              itemBuilder: (context, index) {
                return ScreenShotItem(screenshot: screenshotsToShow[index]);
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 13.h,
              ),
            ),
          ),
          Visibility(
              visible: !hasScreenshots,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'ScreenShots are not available 😥',
                  textAlign: TextAlign.center,
                  style: AppStyles.bold20Roboto
                      .copyWith(color: AppColors.yellowPrimaryColor),
                ),
              ))
        ],
      ),
    );
  }
}
