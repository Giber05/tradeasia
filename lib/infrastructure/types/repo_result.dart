import 'package:trade_asia/infrastructure/types/resource.dart';

enum ResultSource { cache, network }

class Result<T> {
  final T data;
  final ResultSource source;
  final String message;

  const Result({required this.data, required this.source, required this.message});

  Resource<T> get asResource => Resource.success(data, message: message);

  Result<Y> copyWith<Y>({required Y data, String? message, ResultSource? source}) =>
      Result(data: data, source: source ?? this.source, message: message ?? this.message);
}

extension FutureValueExt<T> on Future<T> {
  Future<Result<T>> asResult({String message = "", ResultSource source = ResultSource.network}) async =>
      Result(data: await this, source: source, message: message);
}

extension FutureResultExt<T> on Future<Result<T>> {
  Future<T> get dataFuture async => (await this).data;

  Future<Result<Y>> map<Y>(Y Function(T data) mapper) async {
    final result = await this;
    return result.copyWith(data: mapper(result.data));
  }
}
