import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';


class CustomeElevatedButton extends StatelessWidget {
  const CustomeElevatedButton({
    super.key,
    required this.label,
    this.width,
    required this.onPressed,
    this.backGrounColor,
    this.labelStyle,
    this.labelColor = AppColors.blackPrimaryColor,
  });

  final String label;
  final TextStyle? labelStyle;
  final double? width;
  final VoidCallback onPressed;
  final Color? backGrounColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          backgroundColor: backGrounColor ?? AppColors.yellowPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          fixedSize: Size(width ?? MediaQuery.sizeOf(context).width, 56),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: labelStyle ??
                AppStyles.regular16Roboto.copyWith(
                  color: labelColor,
                  fontSize: 18,
                ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            maxLines: 2, // بيدعم سطرين لو النص طويل
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
