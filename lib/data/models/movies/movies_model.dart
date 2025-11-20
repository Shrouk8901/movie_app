class MoviesModel {
  final int id;
  final String title;
  final String url;
  final String imdbCode;
  final int year;
  final double rating;
  final String poster;

  MoviesModel({
    required this.id,
    required this.title,
    required this.url,
    required this.imdbCode,
    required this.year,
    required this.rating,
    required this.poster,
  });

  factory MoviesModel.fromJson(Map<String, dynamic> json) {
    return MoviesModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      imdbCode: json['imdb_code'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0).toDouble(),
      poster: json['medium_cover_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "url": url,
      "imdb_code": imdbCode,
      "year": year,
      "rating": rating,
      "medium_cover_image": poster,
    };
  }
}
