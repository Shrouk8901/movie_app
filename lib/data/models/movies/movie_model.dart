class MovieModel {
  final int id;
  final String title;
  final String? titleLong;
  final double rating;
  final int runtime;
  final List<String> genres;
  final String? summary;
  final String? descriptionFull;
  final String? language;
  final String? backgroundImage;
  final String? mediumCoverImage;
  final String? largeCoverImage;
  final int year;
  final List<Map<String, dynamic>>? cast;
  final List<String>? screenshots;

  MovieModel({
    required this.id,
    required this.title,
    this.titleLong,
    required this.rating,
    required this.runtime,
    required this.genres,
    this.summary,
    this.descriptionFull,
    this.language,
    this.backgroundImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    required this.year,
    this.cast,
    this.screenshots,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // Parse description fields - البحث في حقول بديلة عندما تكون الحقول الرئيسية فارغة
    final descriptionFull = _parseDescriptionField(json, 'description_full') ??
        _parseDescriptionField(json, 'descriptionFull') ??
        _parseDescriptionField(json, 'summary') ??
        _parseDescriptionField(json, 'plot') ??
        _parseDescriptionField(json, 'overview') ??
        _parseDescriptionField(json, 'synopsis') ??
        _parseDescriptionField(json, 'storyline') ??
        _parseDescriptionField(json, 'description') ??
        _getDescriptionFromOtherSources(json); // البحث في مصادر أخرى

    final summary = _parseDescriptionField(json, 'summary') ??
        _parseDescriptionField(json, 'description') ??
        _parseDescriptionField(json, 'plot') ??
        _parseDescriptionField(json, 'overview') ??
        _parseDescriptionField(json, 'synopsis') ??
        descriptionFull; // استخدام descriptionFull كبديل

    return MovieModel(
      id: _parseInt(json['id']),
      title: _parseString(json['title']),
      titleLong: _parseStringNullable(json['title_long'] ?? json['titleLong']),
      rating: _parseDouble(json['rating'] ?? json['rate'] ?? json['score']),
      runtime: _parseInt(json['runtime'] ?? json['duration']),
      genres: _parseStringList(json['genres'] ?? json['genre']),
      summary: summary,
      descriptionFull: descriptionFull,
      language: _parseStringNullable(json['language'] ?? json['lang']),
      backgroundImage: _parseStringNullable(
        json['background_image'] ??
            json['backgroundImage'] ??
            json['backdrop_path'] ??
            json['backdrop'] ??
            json['large_cover_image'],
      ),
      mediumCoverImage: _parseStringNullable(
        json['medium_cover_image'] ??
            json['mediumCoverImage'] ??
            json['poster_path'] ??
            json['poster'],
      ),
      largeCoverImage: _parseStringNullable(
        json['large_cover_image'] ??
            json['largeCoverImage'] ??
            json['poster_path'] ??
            json['poster'],
      ),
      year: _parseInt(json['year'] ??
          json['release_year'] ??
          _extractYearFromDate(json['date_uploaded'])),
      cast: _parseCastList(json['cast'] ?? json['actors'] ?? json['cast_list']),
      screenshots: _parseScreenshots(
        json['screenshots'] ??
            json['images'] ??
            json['backdrops'] ??
            json['yt_trailer_code'] ??
            json['trailer'] ??
            json['movie_images'] ??
            json['photos'],
      ),
    );
  }

  // دالة مساعدة جديدة للبحث في مصادر أخرى للوصف
  static String? _getDescriptionFromOtherSources(Map<String, dynamic> json) {
    // حاول الحصول على الوصف من title_long إذا كان وصفيًا
    final titleLong = json['title_long'];
    if (titleLong is String && titleLong.length > 30) {
      return titleLong;
    }

    // حاول من الـ synopsis إذا كان موجودًا وغير فارغ
    final synopsis = json['synopsis'];
    if (synopsis is String && synopsis.isNotEmpty) {
      return synopsis;
    }

    // حاول من الـ plot إذا كان موجودًا
    final plot = json['plot'];
    if (plot is String && plot.isNotEmpty) {
      return plot;
    }

    return null;
  }

  // دالة مساعدة لتحليل حقول الوصف
  static String? _parseDescriptionField(
      Map<String, dynamic> json, String fieldName) {
    if (!json.containsKey(fieldName)) {
      return null;
    }

    final value = json[fieldName];

    if (value == null) {
      return null;
    }

    if (value is String) {
      return value.trim().isEmpty ? null : value;
    }

    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleLong': titleLong,
      'rating': rating,
      'runtime': runtime,
      'genres': genres,
      'summary': summary,
      'descriptionFull': descriptionFull,
      'language': language,
      'backgroundImage': backgroundImage,
      'mediumCoverImage': mediumCoverImage,
      'largeCoverImage': largeCoverImage,
      'year': year,
      'cast': cast,
      'screenshots': screenshots,
    };
  }

  // Helper functions
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static String? _parseStringNullable(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value.isEmpty ? null : value;
    }

    final str = value.toString();
    return str.isEmpty ? null : str;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((e) => _parseString(e))
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  static List<Map<String, dynamic>>? _parseCastList(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      return value.map((e) {
        if (e is Map<String, dynamic>) {
          return {
            'name': _parseString(
                e['name'] ?? e['actor'] ?? e['person'] ?? 'Unknown'),
            'character': _parseString(e['character'] ??
                e['character_name'] ??
                e['role'] ??
                'Unknown Character'),
            'image': _parseStringNullable(e['url_small_image'] ??
                e['imdb_code'] ??
                e['image'] ??
                e['photo'] ??
                e['profile_path'] ??
                e['img']),
          };
        }

        if (e is String) {
          return {
            'name': e,
            'character': 'Unknown Character',
            'image': null,
          };
        }

        return {
          'name': 'Unknown',
          'character': 'Unknown Character',
          'image': null,
        };
      }).toList();
    }

    return null;
  }

  static List<String>? _parseScreenshots(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      // معالجة قائمة من URLs
      final screenshots = value
          .map((e) => _parseString(e))
          .where((e) => e.isNotEmpty && e.startsWith('http'))
          .toList();

      if (screenshots.isNotEmpty) return screenshots;
    }

    if (value is String && value.isNotEmpty) {
      // إذا كان trailer code، إنشاء URL للصورة
      return ['https://img.youtube.com/vi/$value/maxresdefault.jpg'];
    }

    if (value is Map<String, dynamic>) {
      // معالجة هيكل nested للصور
      if (value.containsKey('screenshots') && value['screenshots'] is List) {
        return (value['screenshots'] as List)
            .map((e) => _parseString(e))
            .where((e) => e.isNotEmpty && e.startsWith('http'))
            .toList();
      }

      // البحث عن أي قائمة تحتوي على URLs للصور
      for (var key in value.keys) {
        if (value[key] is List) {
          final potentialScreenshots = (value[key] as List)
              .where((e) => e is String && e.startsWith('http'))
              .map((e) => e.toString())
              .toList();

          if (potentialScreenshots.isNotEmpty) {
            return potentialScreenshots;
          }
        }
      }
    }

    return null;
  }

  static int _extractYearFromDate(dynamic dateValue) {
    if (dateValue == null) return 0;
    final dateStr = dateValue.toString();
    if (dateStr.length >= 4) {
      return int.tryParse(dateStr.substring(0, 4)) ?? 0;
    }
    return 0;
  }
}
