import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/domain/entities/product_detail.dart';

abstract class ProductRepository {
  Future<List<Product>> getTopProducts();
  Future<ProductDetail> getProductDetails(String productId);
}
