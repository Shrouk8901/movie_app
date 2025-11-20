import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  //google fonts

  static final TextStyle medium28white = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static final TextStyle regular16gray = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.grey.withValues(alpha: .6),
  );
  static final TextStyle regular16white = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  static final TextStyle regular20white = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  static final TextStyle semiBold20black = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.blackPrimaryColor,
  );
  static final TextStyle bold20white = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle regular16Roboto = GoogleFonts.roboto(
      fontSize: 16,
      color: AppColors.yellowPrimaryColor,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none);

  static final TextStyle regular20Roboto = GoogleFonts.roboto(
      fontSize: 20,
      color: AppColors.white,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none);

  static final TextStyle bold20Roboto = GoogleFonts.roboto(
      fontSize: 20,
      color: AppColors.offWhite,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static final TextStyle bold24Roboto = GoogleFonts.roboto(
      fontSize: 24,
      color: AppColors.white,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);
}
