import 'package:dio/dio.dart';

enum ResponseType { success, error }

class ApiResponse<T> {
  ResponseType type;
  T? data;

  ApiResponse({required this.type, this.data});
}

class ApiResponseHandler {
  static ApiResponse<T?> handleResponse<T>(
    Response response, {
    required T Function(dynamic) onSuccess,
    ApiResponse<T?> Function(DioError)? onError,
  }) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return ApiResponse(
        type: ResponseType.success,
        data: onSuccess(response.data),
      );
    } else {
      if (onError != null) {
        final errorResponse = DioError(
          requestOptions: response.requestOptions,
          response: response,
        );
        return onError(errorResponse);
      } else {
        return ApiResponse(type: ResponseType.error);
      }
    }
  }
}

class ApiService {
  final Dio _dio;

  ApiService({required String baseUrl}) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<ApiResponse<T?>> get<T>(
    String endpoint,
    T Function(dynamic data) fromJson, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return ApiResponseHandler.handleResponse(
        response,
        onSuccess: (data) => fromJson(data),
      );
    } on DioError catch (error) {
      return ApiResponseHandler.handleResponse(
        error.response!,
        onSuccess: (data) => fromJson(data),
        onError: (err) => ApiResponse(type: ResponseType.error),
      );
    }
  }
}
