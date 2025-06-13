import 'package:flutter/services.dart';

enum ENV {
  prod(
    apiKey: "a8da6ae699438e7785dbe0d8aae4caf8bb053208",
    baseURL: "https://tradeasia.co/api/test",
    database: "TRADEASIA_MOBILE_PROD",
    serviceName: 'TradeAsia Mobile',
  ),
  // ngrok(
  //     baseURL: "https://9eb5-103-154-138-61.ngrok-free.app/",
  //     database: "refasto"),
  dev(
    apiKey: "a8da6ae699438e7785dbe0d8aae4caf8bb053208",
    baseURL: "https://tradeasia.co/api/test",
    database: "TRADEASIA_MOBILE_DEV",
    serviceName: 'TradeAsia Mobile Dev',
  );

  final String baseURL;
  final String database;
  final String apiKey;
  final String serviceName;

  const ENV({required this.baseURL, required this.database, required this.apiKey, required this.serviceName});

  static ENV _current = ENV.dev;

  static ENV get current {
    if (appFlavor == null) return _current;
    switch (appFlavor) {
      case 'prod':
        return ENV.prod;
      case 'staging':
        return ENV.dev;
      default:
        return ENV.dev;
    }
  }

  // API Endpoints
  String get topProductsEndpoint => '$baseURL/topProducts';
  String productDetailsEndpoint(String id) => '$baseURL/productDetails/$id';
}
