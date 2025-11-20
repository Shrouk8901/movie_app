import 'package:movies_app/data/models/movies/movie_basic_info.dart';

class AddFavResponse {
  final String message;
  final MovieBasicInfo movieBasicInfo;

  const AddFavResponse({required this.message,required this.movieBasicInfo});

  factory AddFavResponse.fromJson(Map<String, dynamic> json) {
    return AddFavResponse(
      message: json['message'] as String,
      movieBasicInfo: MovieBasicInfo.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
