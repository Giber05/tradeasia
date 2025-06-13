import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/network/client/api_client.dart';
import 'package:trade_asia/infrastructure/types/exception/exception.dart';
import 'package:trade_asia/modules/product/data/datasources/product_remote_dts.dart';
import 'package:trade_asia/modules/product/data/models/product_dto.dart';
import 'package:trade_asia/modules/product/data/models/product_detail_dto.dart';

@LazySingleton(as: ProductRemoteDts)
class ProductRemoteDtsImpl implements ProductRemoteDts {
  final APIClient _apiClient;
  final TopProductsResponseDtoMapper _topProductsMapper = TopProductsResponseDtoMapper();
  final ProductDetailResponseDtoMapper _productDetailMapper = ProductDetailResponseDtoMapper();

  ProductRemoteDtsImpl(this._apiClient);

  @override
  Future<TopProductsResponseDto> getTopProducts() async {
    try {
      final result = await _apiClient.get<TopProductsResponseDto>(
        path: '/topProducts',
        mapper: (json, headers) => _topProductsMapper.fromJSON(json),
      );
      return result.data;
    } on BaseException {
      rethrow;
    } catch (e) {
      throw BaseException(message: 'Failed to fetch top products: $e');
    }
  }

  @override
  Future<ProductDetailResponseDto> getProductDetails(String productId) async {
    try {
      final result = await _apiClient.get<ProductDetailResponseDto>(
        path: '/productDetails/$productId',
        mapper: (json, headers) => _productDetailMapper.fromJSON(json),
      );
      return result.data;
    } on BaseException {
      rethrow;
    } catch (e) {
      throw BaseException(message: 'Failed to fetch product details: $e');
    }
  }
}
