import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/l10n/app_localizations.dart';

import '../../../../data/models/movies/movie_model.dart';

class MovieCast extends StatelessWidget {
  const MovieCast({
    super.key,
    required this.image,
    required this.character,
    required this.name,
  });

  final String image;
  final String character;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11.h),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Cast member image with network support and error handling
          _buildCastImage(),
          SizedBox(width: 15.w),
          // Cast member details with the format you want
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.name} : ',
                        style: AppStyles.regular16Roboto.copyWith(
                          color: AppColors.yellowPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: name,
                        style: AppStyles.regular16Roboto.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.character} : ',
                        style: AppStyles.regular16Roboto.copyWith(
                          color: AppColors.yellowPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: character,
                        style: AppStyles.regular16Roboto.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCastImage() {
    // If no image or invalid URL, show placeholder
    if (image.isEmpty ||
        image == 'null' ||
        image == 'assets/images/placeholder_cast.png' ||
        !image.startsWith('http')) {
      return _buildPlaceholderImage();
    }

    // Try to load network image
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          image,
          width: 80.w,
          height: 80.h,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.yellowPrimaryColor,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            log('❌ Failed to load cast image: $image, error: $error');
            return _buildPlaceholderImage();
          },
        ),
      );
    } catch (e) {
      log('❌ Exception loading cast image: $e');
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.boldgrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const Icon(
        Icons.person,
        color: AppColors.white,
        size: 34,
      ),
    );
  }
}

class MovieCastHandling extends StatelessWidget {
  final MovieModel movie;

  const MovieCastHandling({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final hasCast = movie.cast != null && movie.cast!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cast Section
          Text(
            AppLocalizations.of(context)!.cast,
            style: AppStyles.bold24Roboto.copyWith(color: AppColors.white),
          ),
          if (hasCast) ...[
            SizedBox(height: 16.h),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movie.cast!.length,
              itemBuilder: (context, index) {
                final castMember = movie.cast![index];
                final characterName =
                    castMember['character'] ??AppLocalizations.of(context)!.unknown_character;

                return MovieCast(
                  name: castMember['name'] ?? AppLocalizations.of(context)!.unknown,
                  character: characterName,
                  image: castMember['image'] ??
                      'assets/images/placeholder_cast.png',
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.no_cast_info,
              style: AppStyles.regular16Roboto.copyWith(color: AppColors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
