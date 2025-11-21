import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/api_endpoints.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/data/models/movies/movies_model.dart';

class MoviesRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<List<MoviesModel>> fetchMovies({
    int page = 1,
    int limit = 20,
    String? genre,
    String sortBy = "year",
    String orderBy = "desc",
    bool forceRefresh = false,
  }) async {
    try {
      final queryParams = {
        "page": page,
        "limit": limit,
        "sort_by": sortBy,
        "order_by": orderBy,
        if (genre != null && genre.isNotEmpty) "genre": genre,
        if (forceRefresh) "t": DateTime.now().millisecondsSinceEpoch,
      };

      final response = await _dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.listMovies}",
        queryParameters: queryParams,
      );

      // Debug print
      print("MOVIES RESPONSE: ${response.data}");

      // Basic safety checks
      if (response.statusCode != 200 || response.data == null) {
        throw APIException("Failed: Bad status code or empty response");
      }

      if (response.data["status"] != "ok") {
        final msg = response.data["status_message"] ?? "Unknown YTS Error";
        throw APIException(msg);
      }

      final List moviesJson = response.data["data"]["movies"] ?? [];
      return moviesJson
          .map((m) => MoviesModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("FETCH MOVIES ERROR: $e");
      throw APIException(e.toString());
    }
  }
}
