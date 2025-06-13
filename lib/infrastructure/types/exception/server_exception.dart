import 'package:trade_asia/infrastructure/types/exception/exception.dart';

class ServerException extends BaseException {
  final int statusCode;

  const ServerException({required super.message, required this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}
