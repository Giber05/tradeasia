import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/architecture/usecase.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';
import 'package:trade_asia/modules/product/domain/entities/product_detail.dart';
import 'package:trade_asia/modules/product/domain/repositories/product_repository.dart';

@injectable
class GetProductDetailsUseCase extends Usecase<String, ProductDetail> {
  final ProductRepository _repository;

  GetProductDetailsUseCase(this._repository);

  @override
  Future<Resource<ProductDetail>> execute(String productId) async {
    if (productId.isEmpty) {
      throw ArgumentError('Product ID cannot be empty');
    }

    final productDetail = await _repository.getProductDetails(productId);
    return Resource.success(productDetail);
  }
}
