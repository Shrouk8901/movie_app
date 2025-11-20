import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';

class ScreenShotItem extends StatelessWidget {
  const ScreenShotItem({super.key, required this.screenshot});
  final String screenshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          screenshot,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              height: 170.h,
              color: AppColors.grey,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.yellowPrimaryColor,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 200,
              color: AppColors.grey,
              child: const Icon(
                Icons.broken_image,
                color: AppColors.white,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}
