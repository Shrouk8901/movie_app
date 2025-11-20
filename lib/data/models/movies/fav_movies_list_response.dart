import 'movie_basic_info.dart';

class FavMoviesListResponse {
  final String message;
  final List<MovieBasicInfo> data;

  const FavMoviesListResponse({required this.message, required this.data});

  factory FavMoviesListResponse.fromJson(Map<String, dynamic> json) {
    return FavMoviesListResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => MovieBasicInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
