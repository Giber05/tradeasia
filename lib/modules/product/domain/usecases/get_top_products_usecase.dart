import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/architecture/usecase.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/domain/repositories/product_repository.dart';

@injectable
class GetTopProductsUseCase extends UsecaseNoParams<List<Product>> {
  final ProductRepository _repository;

  GetTopProductsUseCase(this._repository);

  @override
  Future<Resource<List<Product>>> execute() async {
    final products = await _repository.getTopProducts();
    return Resource.success(products);
  }
}
