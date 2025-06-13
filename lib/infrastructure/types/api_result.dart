import 'package:trade_asia/infrastructure/types/repo_result.dart';

class APIResult<T> extends Result<T> {
  final dynamic status;

  const APIResult({required super.data, required super.message, required this.status})
    : super(source: ResultSource.network);
}

extension APIResultExt<T> on Future<APIResult<T>> {
  Future<T> get futureData async => (await this).data;
}
