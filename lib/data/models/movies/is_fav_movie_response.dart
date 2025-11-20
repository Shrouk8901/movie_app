class IsFavMovieResponse {
  final String message;
  final bool isFav;

  const IsFavMovieResponse({required this.message, required this.isFav});

  factory IsFavMovieResponse.fromJson(Map<String, dynamic> json) {
    return IsFavMovieResponse(
      message: json['message'] as String,
      isFav: json['data'] as bool,
    );
  }
}
