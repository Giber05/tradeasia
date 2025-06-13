import 'package:trade_asia/modules/product/data/models/product_dto.dart';
import 'package:trade_asia/modules/product/data/models/product_detail_dto.dart';

abstract class ProductRemoteDts {
  Future<TopProductsResponseDto> getTopProducts();
  Future<ProductDetailResponseDto> getProductDetails(String productId);
}
