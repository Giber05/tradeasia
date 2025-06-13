class NetworkConstants {
  const NetworkConstants._();

  // Timeout values
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Headers
  static const String contentTypeHeader = 'content-type';
  static const String acceptHeader = 'accept';
  static const String authorizationHeader = 'Authorization';
  static const String serviceNameHeader = 'service-name';
  static const String cookieHeader = 'Cookie';

  // Content types
  static const String applicationJson = 'application/json';

  // Log tags
  static const String requestLogTag = 'API_CALL_REQUEST';
  static const String responseLogTag = 'API_CALL_RESPONSE';
}
