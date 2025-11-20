import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/l10n/app_localizations.dart';

import '../../../../core/constants/styles/app_styles.dart';
import 'genres_item.dart';

class MovieGenres extends StatelessWidget {
  final List<String> genres;

  const MovieGenres({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.genres,
              style: AppStyles.bold24Roboto.copyWith(fontSize: 24.sp)),
          SizedBox(height: 12),
          genres.isEmpty
              ? SizedBox(
                  height: 56,
                  child: Center(
                    child: Text('No genres available',
                        style: AppStyles.regular16Roboto),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  itemCount: genres.length,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 11.h,
                      childAspectRatio: 140 / 66),
                  itemBuilder: (context, index) =>
                      GenresItem(type: genres[index]),
                )
        ],
      ),
    );
  }
}
