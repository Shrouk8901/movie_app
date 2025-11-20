import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import '../../../../core/constants/styles/app_styles.dart';
import '../../../../data/models/movies/movie_model.dart';
import '../custom_film_poster.dart';

class SuggestedMovies extends StatelessWidget {
  final List<MovieModel> similarMovies;

  final void Function(int index) onTap;

  const SuggestedMovies(
      {super.key, required this.similarMovies, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.similar,
              style: AppStyles.bold24Roboto),
          SizedBox(height: 10.h),
          similarMovies.isEmpty
              ? SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.similar_not_found,
                        style: AppStyles.regular16Roboto),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 189 / 279,
                  ),
                  itemCount: similarMovies.length,
                  itemBuilder: (context, index) => CustomFilmPoster(
                    height: double.infinity,
                    width: double.infinity,
                    imagePath: similarMovies[index].mediumCoverImage ?? '',
                    rating: similarMovies[index].rating.toStringAsFixed(1),
                    onTap: () {
                      onTap(index);
                    },
                  ),
                )
        ],
      ),
    );
  }
}
