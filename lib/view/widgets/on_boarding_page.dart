import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';
import 'package:movies_app/l10n/app_localizations.dart';

import '../../core/constants/styles/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String image, title;
  final String? desc;
  final VoidCallback onNext, onSkip;
  final VoidCallback? onBack;
  final bool isLast;
  final bool isSecond;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    this.desc,
    required this.onNext,
    required this.onSkip,
    this.onBack,
    required this.isLast,
    this.isSecond = false,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),

        /// الـ Bottom sheet
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.blackPrimaryColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppStyles.bold20white),
                SizedBox(height: screenHeight * 0.02),

                ///  desc يظهر بس لو مش null أو مش فاضي
                if (desc != null && desc!.isNotEmpty) ...[
                  Text(
                    desc!,
                    textAlign: TextAlign.center,
                    style: AppStyles.regular16white,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],

                if (isSecond) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowPrimaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textStyle: AppStyles.semiBold20black,
                        ),
                        child: Text(AppLocalizations.of(context)!.next,
                            style: AppStyles.semiBold20black),
                      ),
                    ],
                  ),
                ] else ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (onBack != null)
                        OutlinedButton(
                          onPressed: onBack,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: AppColors.yellowPrimaryColor, width: 2),
                            foregroundColor: AppColors.yellowPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            textStyle: AppStyles.semiBold20black,
                          ).copyWith(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppColors.yellowPrimaryColor;
                                }
                                return null;
                              },
                            ),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.black;
                                }
                                return AppColors.yellowPrimaryColor;
                              },
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.back),
                        ),
                      ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowPrimaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textStyle: AppStyles.semiBold20black,
                        ),
                        child: Text(
                            isLast
                                ? AppLocalizations.of(context)!.finish
                                : AppLocalizations.of(context)!.next,
                            style: AppStyles.semiBold20black),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
