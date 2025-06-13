import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/services/cache_service.dart';
import 'package:trade_asia/infrastructure/services/connectivity_service.dart';
import 'package:trade_asia/infrastructure/types/exception/connection_exception.dart';
import 'package:trade_asia/modules/product/data/datasources/product_remote_dts.dart';
import 'package:trade_asia/modules/product/data/models/product_mapper.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/domain/entities/product_detail.dart';
import 'package:trade_asia/modules/product/domain/repositories/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDts _remoteDts;
  final CacheService _cacheService;
  final ConnectivityService _connectivityService;

  static const Duration _cacheExpiration = Duration(hours: 1);

  ProductRepositoryImpl(this._remoteDts, this._cacheService, this._connectivityService);

  @override
  Future<List<Product>> getTopProducts() async {
    final cacheKey = CacheKeys.topProducts;

    // Try to get from cache first
    if (!await _cacheService.isExpired(cacheKey, _cacheExpiration)) {
      final cachedProducts = await _cacheService.getList<Product>(cacheKey, (json) => Product.fromJson(json));
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
    }

    // Check connectivity
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) {
      // Try to return cached data even if expired
      final cachedProducts = await _cacheService.getList<Product>(cacheKey, (json) => Product.fromJson(json));
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      throw const ConnectionException(message: 'No internet connection and no cached data available');
    }

    // Fetch from network
    try {
      final response = await _remoteDts.getTopProducts();
      final products = ProductMapper.fromDtoList(response.data.topProduct.data);

      // Cache the result
      await _cacheService.storeList<Product>(cacheKey, products, (product) => product.toJson());

      return products;
    } catch (e) {
      // If network fails, try to return cached data
      final cachedProducts = await _cacheService.getList<Product>(cacheKey, (json) => Product.fromJson(json));
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  @override
  Future<ProductDetail> getProductDetails(String productId) async {
    final cacheKey = CacheKeys.productDetail(productId);

    // Try to get from cache first
    if (!await _cacheService.isExpired(cacheKey, _cacheExpiration)) {
      final cachedProduct = await _cacheService.getObject<ProductDetail>(
        cacheKey,
        (json) => ProductDetail.fromJson(json),
      );
      if (cachedProduct != null) {
        return cachedProduct;
      }
    }

    // Check connectivity
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) {
      // Try to return cached data even if expired
      final cachedProduct = await _cacheService.getObject<ProductDetail>(
        cacheKey,
        (json) => ProductDetail.fromJson(json),
      );
      if (cachedProduct != null) {
        return cachedProduct;
      }
      throw const ConnectionException(message: 'No internet connection and no cached data available');
    }

    // Fetch from network
    try {
      final response = await _remoteDts.getProductDetails(productId);
      final productDetail = ProductDetailMapper.fromDto(
        response.data.productDetail,
        response.data.relatedProduct,
        response.data.basicInfo,
      );

      // Cache the result
      await _cacheService.storeObject<ProductDetail>(cacheKey, productDetail, (product) => product.toJson());

      return productDetail;
    } catch (e) {
      // If network fails, try to return cached data
      final cachedProduct = await _cacheService.getObject<ProductDetail>(
        cacheKey,
        (json) => ProductDetail.fromJson(json),
      );
      if (cachedProduct != null) {
        return cachedProduct;
      }
      rethrow;
    }
  }
}
