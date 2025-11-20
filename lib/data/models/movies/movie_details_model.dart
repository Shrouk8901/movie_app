import 'movie_model.dart';

class MovieDetailsResponse {
  final String status;
  final String statusMessage;
  final MovieDetailsData? data;
  final Map<String, dynamic>? meta;

  MovieDetailsResponse({
    required this.status,
    required this.statusMessage,
    this.data,
    this.meta,
  });

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    dynamic movieData;

    if (json.containsKey('data')) {
      movieData = json['data'];

      if (movieData is Map<String, dynamic> && movieData.containsKey('movie')) {
        movieData = movieData['movie'];
      } else if (movieData is Map<String, dynamic> &&
          (movieData.containsKey('id') || movieData.containsKey('title'))) {
        // movieData remains as is
      }
    } else if (json.containsKey('movie')) {
      movieData = json['movie'];
    } else if (json.containsKey('id') || json.containsKey('title')) {
      movieData = json;
    } else {
      movieData = json;
    }

    return MovieDetailsResponse(
      status: _parseString(json['status']),
      statusMessage:
          _parseString(json['status_message'] ?? json['statusMessage']),
      data: movieData is Map<String, dynamic>
          ? MovieDetailsData.fromJson(movieData)
          : MovieDetailsData.fromJson({}),
      meta: json['@meta'] != null
          ? Map<String, dynamic>.from(json['@meta'])
          : null,
    );
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}

class MovieDetailsData {
  final MovieModel? movie;

  MovieDetailsData({this.movie});

  factory MovieDetailsData.fromJson(Map<String, dynamic> json) {
    // If the json already contains movie data at the top level
    if (json.containsKey('id') && json.containsKey('title')) {
      return MovieDetailsData(
        movie: MovieModel.fromJson(json),
      );
    }

    // If the json has a 'movie' key
    if (json.containsKey('movie')) {
      final movieJson = json['movie'];
      if (movieJson is Map<String, dynamic>) {
        return MovieDetailsData(
          movie: MovieModel.fromJson(movieJson),
        );
      }
    }

    return MovieDetailsData(movie: null);
  }
}
