import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // Get story IDs based on type
  Future<List<int>> getStoryIds(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return List<int>.from(response.data as List);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get individual story by ID
  Future<Map<String, dynamic>> getStory(int id) async {
    try {
      final response = await _dio.get(ApiConstants.item(id));
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get multiple stories by IDs
  Future<List<Map<String, dynamic>>> getStories(List<int> ids) async {
    try {
      final futures = ids.map((id) => getStory(id)).toList();
      return await Future.wait(futures);
    } catch (e) {
      rethrow;
    }
  }

  // Get comment by ID
  Future<Map<String, dynamic>> getComment(int id) async {
    try {
      final response = await _dio.get(ApiConstants.item(id));
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get multiple comments by IDs
  Future<List<Map<String, dynamic>>> getComments(List<int> ids) async {
    try {
      final futures = ids.map((id) => getComment(id)).toList();
      final results = await Future.wait(futures);
      // Filter out null/empty results
      return results.where((result) => result.isNotEmpty).toList();
    } catch (e) {
      rethrow;
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error occurred';
    }
  }
}