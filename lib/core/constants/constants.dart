class ApiConstants {
  static const String baseUrl = 'https://route-movie-apis.vercel.app/';
  static const String registerEndpoint = 'auth/register';
  static const String loginEndpoint = 'auth/login';
  static const String resetPasswordEndPoint = 'auth/reset-password';
  static const String profileEndPoint = 'profile';
  static const String isMovieFavEndPoint = 'favorites/is-favorite/';
  static const String getAllFavMoviesEndPoint = 'favorites/all';
  static const String removeFromFavMoviesEndPoint = 'favorites/remove';
  static const String addToFavMoviesEndPoint = 'favorites/add';
}

class Constants {
  static const String tokenKey = 'token';
  static const String loggedKey = 'logged';
  static const String languageKey = 'language';
  static const String sennOnboardingKey = 'senn_onBoarding';
  static const String cacheKey = "cached_movies";
  static const String recentKey = "recent_movies";
}
