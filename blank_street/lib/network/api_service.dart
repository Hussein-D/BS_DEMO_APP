import 'package:blank_street/core/type_defs/api_service_output.dart';
import 'package:blank_street/models/error_data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://127.0.0.1:4000"));
  Map<String, dynamic> _getHeaders({Map<String, dynamic>? h}) {
    Map<String, dynamic> headers = {"Content-Type": "application/json"};
    if (h == null) {
      return headers;
    } else {
      headers.addAll(h);
      return headers;
    }
  }

  ApiServiceOutput<List<T>> getList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: _getHeaders(h: headers),
          contentType: headers?["Content-Type"] ?? Headers.jsonContentType,
        ),
      );
      if ((result.statusCode ?? 500) >= 200 &&
          (result.statusCode ?? 500) <= 300) {
        final List<T> data = (result.data as List)
            .map((e) => fromJson(e))
            .toList();
        return Right(data);
      } else {
        return Left(
          ErrorDataModel(
            message: result.statusMessage ?? "",
            statusCode: result.statusCode ?? 500,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorDataModel(message: "Unexpected Error", statusCode: 500));
    }
  }

  ApiServiceOutput<T> getRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(h: headers)),
      );
      if ((result.statusCode ?? 500) >= 200 &&
          (result.statusCode ?? 500) <= 300) {
        final T data = fromJson(result.data);
        return Right(data);
      } else {
        return Left(
          ErrorDataModel(
            message: result.statusMessage ?? "",
            statusCode: result.statusCode ?? 500,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorDataModel(message: "Unexpected Error", statusCode: 500));
    }
  }

  ApiServiceOutput<T> postRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> bodyData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _dio.post(
        endpoint,
        data: bodyData,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(h: headers)),
      );

      if ((result.statusCode ?? 500) >= 200 &&
          (result.statusCode ?? 500) <= 300) {
        final data = fromJson(result.data);
        return Right(data);
      } else {
        return Left(
          ErrorDataModel(
            message: result.statusMessage ?? "",
            statusCode: result.statusCode ?? 500,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorDataModel(message: "Unexpected Error", statusCode: 500));
    }
  }
}
