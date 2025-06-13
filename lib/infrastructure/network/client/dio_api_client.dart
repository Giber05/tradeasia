import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/env/env.dart';
import 'package:trade_asia/infrastructure/network/client/api_client.dart';
import 'package:trade_asia/infrastructure/types/api_result.dart';
import 'package:trade_asia/infrastructure/types/exception/connection_exception.dart';
import 'package:trade_asia/infrastructure/types/exception/exception.dart';
import 'package:trade_asia/infrastructure/types/exception/server_exception.dart';

/// Direct implementation of the APIClient interface using Dio
@LazySingleton(as: APIClient)
class DioApiClient extends APIClient {
  late final Dio _dio;

  DioApiClient() : super(ENV.current.baseURL) {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, requestHeader: true, responseHeader: true),
      );
    }
  }

  @override
  String buildFullUrl(String extraPath) {
    return extraPath.startsWith('http') ? extraPath : '$baseURL$extraPath';
  }

  @override
  Future<APIResult<T>> get<T>({
    required String path,
    Map<String, String>? headers,
    required MapFromNetwork<T> mapper,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    String? bearerToken,
    JSON? body,
    MockedResult? mockResult,
  }) async {
    return _makeRequest<T>(
      method: 'GET',
      path: path,
      headers: headers,
      mapper: mapper,
      query: query,
      bearerToken: bearerToken,
      body: body,
      mockResult: mockResult,
    );
  }

  @override
  Future<APIResult<T>> post<T>({
    required String path,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    JSON? body,
    String? bearerToken,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) async {
    return _makeRequest<T>(
      method: 'POST',
      path: path,
      headers: headers,
      mapper: mapper,
      query: query,
      bearerToken: bearerToken,
      body: body,
      mockResult: mockResult,
    );
  }

  @override
  Future<APIResult<T>> put<T>({
    required String path,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    JSON? body,
    String? bearerToken,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) async {
    return _makeRequest<T>(
      method: 'PUT',
      path: path,
      headers: headers,
      mapper: mapper,
      query: query,
      bearerToken: bearerToken,
      body: body,
      mockResult: mockResult,
    );
  }

  @override
  Future<APIResult<T>> delete<T>({
    required String path,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    JSON? body,
    String? bearerToken,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) async {
    return _makeRequest<T>(
      method: 'DELETE',
      path: path,
      headers: headers,
      mapper: mapper,
      query: query,
      bearerToken: bearerToken,
      body: body,
      mockResult: mockResult,
    );
  }

  @override
  Future<APIResult<T>> multipartRequest<T>({
    required String path,
    required HttpRequestType requestType,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    Future<APIResult<T>?> Function(http.Response response)? plainHandler,
    Map<String, dynamic> fields = const {},
    String? bearerToken,
    query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  }) async {
    // Implementation for multipart requests
    throw UnimplementedError('Multipart requests not implemented yet');
  }

  Future<APIResult<T>> _makeRequest<T>({
    required String method,
    required String path,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    String? bearerToken,
    JSON? body,
    MockedResult? mockResult,
  }) async {
    try {
      // Handle mocked results for testing
      if (mockResult != null) {
        return APIResult<T>(
          data: mapper(mockResult.result, mockResult.headers),
          message: 'Mocked response',
          status: mockResult.statusCode,
        );
      }

      final url = buildFullUrl(path);
      final options = Options(
        method: method,
        headers: {
          'Content-Type': 'application/json',
          if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
          ...?headers,
        },
      );

      final response = await _dio.request(url, options: options, queryParameters: query, data: body);

      final responseHeaders = <String, String>{};
      response.headers.forEach((key, value) {
        responseHeaders[key] = value.join(', ');
      });

      return APIResult<T>(
        data: mapper(response.data, responseHeaders),
        message: 'Success',
        status: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw BaseException.unknownError();
    }
  }

  BaseException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = error.response?.data?.toString() ?? 'Server error';
        return ServerException(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return const BaseException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return const ConnectionException(message: 'No internet connection');
      default:
        return BaseException.unknownError();
    }
  }
}
