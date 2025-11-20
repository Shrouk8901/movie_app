class MovieBasicInfo {
  final String movieId;
  final String name;
  final double rating;
  final String imageUrl;
  final String year;

  const MovieBasicInfo({
    required this.movieId,
    required this.name,
    required this.rating,
    required this.imageUrl,
    required this.year,
  });

  factory MovieBasicInfo.fromJson(Map<String, dynamic> json) => MovieBasicInfo(
        movieId: json['movieId'] as String,
        name: json['name'] as String,
        rating: (json['rating'] as num).toDouble(),
        imageUrl: json['imageURL'] as String,
        year: json['year'] as String,
      );

  Map<String, dynamic> toJson() => {
        'movieId': movieId,
        'name': name,
        'rating': rating,
        'imageURL': imageUrl,
        'year': year,
      };
}
