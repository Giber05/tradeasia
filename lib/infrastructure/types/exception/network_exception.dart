import 'package:trade_asia/infrastructure/types/exception/exception.dart';

class NetworkException extends BaseException {
  final int statusCode;

  const NetworkException({required super.message, required this.statusCode});
}

class ConnectionException extends BaseException {
  const ConnectionException()
    : super(message: "Can't connect to the server. Make sure you have a good internet connection");
}
