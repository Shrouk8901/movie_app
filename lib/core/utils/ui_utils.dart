import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/styles/app_colors.dart';
import 'package:movies_app/core/constants/styles/app_styles.dart';

class UIUtils {
  static void showLoading(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.yellowPrimaryColor,
              ),
            ),
          ),
        ),
      );

  static void hideLoading(BuildContext context) => Navigator.of(context).pop();

  static void showMessage(
          String message, BuildContext context, Color backgroundColor) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: backgroundColor,
          content: Center(
              child: Text(
            message,
            style:
                AppStyles.regular16white.copyWith(fontWeight: FontWeight.bold),
          ))));
}
