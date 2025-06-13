import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/types/api_result.dart';

typedef JSON = dynamic;

typedef MapFromNetwork<T> = T Function(dynamic json, Map<String, String> headers);

class RPCRequestBody {
  const RPCRequestBody._();

  static Map<String, dynamic> toJson<T>(dynamic data) => {"jsonrpc": "2.0", "params": data};
}

class MockedResult {
  final dynamic result;
  final int statusCode;
  final Map<String, String> headers;

  const MockedResult({this.result, this.statusCode = 200, this.headers = const {}});
}

class MultiPartFileField {
  final String filepath;

  MultiPartFileField({required this.filepath});
}

enum HttpRequestType {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE');

  final String value;
  const HttpRequestType(this.value);

  static HttpRequestType fromEnumText(String enumText) {
    return values.firstWhere(
      (value) => value.value == enumText.toUpperCase(),
      orElse: () => throw ArgumentError('Invalid enumText of HttpRequestType: $enumText'),
    );
  }
}

abstract class APIClient {
  final String baseURL;

  const APIClient(this.baseURL);

  String buildFullUrl(String extraPath);

  Future<APIResult<T>> post<T>({
    required String path,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    JSON? body,
    String? bearerToken,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  Future<APIResult<T>> get<T>({
    required String path,
    Map<String, String>? headers,
    required MapFromNetwork<T> mapper,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    String? bearerToken,
    JSON? body,
    MockedResult? mockResult,
  });

  Future<APIResult<T>> delete<T>({
    required String path,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    JSON? body,
    String? bearerToken,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  Future<APIResult<T>> put<T>({
    required String path,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    JSON? body,
    String? bearerToken,
    Map<String, dynamic>? query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });

  Future<APIResult<T>> multipartRequest<T>({
    required String path,
    required HttpRequestType requestType,
    required MapFromNetwork<T> mapper,
    Map<String, String>? headers,
    Future<APIResult<T>?> Function(http.Response response) plainHandler,
    Map<String, dynamic> fields = const {},
    String? bearerToken,
    query,
    bool shouldPrint = false,
    MockedResult? mockResult,
  });
}

class MultipartRequestBody {
  final String filePath;
  final String key;
  MultipartRequestBody({required this.filePath, required this.key});

  Map<String, dynamic> toJson() => {"key": key, "filePath": filePath};

  @override
  String toString() {
    return '''
    {
      key:$key,
      filePath:$filePath
    }
    ''';
  }
}

@module
abstract class HttpClientModule {
  http.Client httpClient() => http.Client();
}
