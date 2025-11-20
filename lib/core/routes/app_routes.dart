import 'package:flutter/material.dart';

class AppRoutes {
  static const String onBoardingScreenRoute = "onboarding_screen";
  static const String registerScreenRoute = "register_screen";
  static const String loginScreenRoute = "login_screen";
  static const String forgetPasswordScreenRoute = "forget_screen";
  static const String updateProfileScreenRoute = "update_profile_screen";
  static const String homeScreenRoute = "home_screen";
  static const String splashScreenRoute = "splash_screen";
  static const String movieDetailsRoute = "movie_details";

 static void navigateToMovieDetails(
  BuildContext context, {
  required int movieId,
}) {
  Navigator.pushNamed(
    context,
    AppRoutes.movieDetailsRoute,
    arguments: movieId,
  );
}
}
