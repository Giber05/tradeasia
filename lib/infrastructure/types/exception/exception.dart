import 'package:equatable/equatable.dart';

class BaseException extends Equatable implements Exception {
  final String message;

  const BaseException({required this.message});

  static const _unknownError = "Unknown Error";

  const BaseException.unknownError() : message = _unknownError;

  bool get isUnknownError => message == _unknownError;

  @override
  List<Object?> get props => [message];
}
