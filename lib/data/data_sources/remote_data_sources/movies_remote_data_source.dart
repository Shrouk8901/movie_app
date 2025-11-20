import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/api_endpoints.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:movies_app/data/models/movies/movies_model.dart';

class MoviesRemoteDataSource {
  final Dio _dio = Dio();

  Future<List<MoviesModel>> fetchMovies({
    int? page,
    int? limit,
    String? genre,
    String sortBy = "year",
    String orderBy = "desc", 
    required bool forceRefresh,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        "page": page,
        "limit": limit,
        "genre": genre,
        "sort_by": sortBy,
        "order_by": orderBy,
      };

      if (forceRefresh) {
        queryParams["t"] = DateTime.now().millisecondsSinceEpoch;
      }
      
      queryParams.removeWhere((key, value) => value == null);
      
      final response = await _dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.listMovies,
        queryParameters: queryParams,
      );

      if (response.data["status"] != "ok") {
        throw APIException("Failed to fetch movies");
      }

      final List moviesJson = response.data["data"]["movies"] ?? [];
      return moviesJson
          .map((m) => MoviesModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw APIException(e.toString());
    }
  }
}