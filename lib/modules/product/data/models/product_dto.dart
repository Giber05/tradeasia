import 'package:equatable/equatable.dart';
import 'package:trade_asia/infrastructure/types/mapper/json_mapper.dart';

class ProductDto extends Equatable {
  final int id;
  final String productImage;
  final String productName;
  final String casNumber;
  final String iupacName;
  final String hsCode;
  final String formula;
  final int priority;

  const ProductDto({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.casNumber,
    required this.iupacName,
    required this.hsCode,
    required this.formula,
    required this.priority,
  });

  @override
  List<Object?> get props => [id, productImage, productName, casNumber, iupacName, hsCode, formula, priority];
}

class ProductDtoMapper extends FromJSONMapper<ProductDto> {
  @override
  ProductDto fromJSON(dynamic json) {
    return ProductDto(
      id: parse<int>(json['id']),
      productImage: parse<String>(json['productimage'] ?? ''),
      productName: parse<String>(json['productname'] ?? ''),
      casNumber: parse<String>(json['cas_number'] ?? ''),
      iupacName: parse<String>(json['iupac_name'] ?? ''),
      hsCode: parse<String>(json['hs_code'] ?? ''),
      formula: parse<String>(json['formula'] ?? ''),
      priority: parse<int>(json['priority'] ?? 0),
    );
  }
}

class TopProductsResponseDto extends Equatable {
  final bool status;
  final TopProductsDataDto data;
  final String message;

  const TopProductsResponseDto({required this.status, required this.data, required this.message});

  @override
  List<Object?> get props => [status, data, message];
}

class TopProductsDataDto extends Equatable {
  final TopProductsPaginationDto topProduct;

  const TopProductsDataDto({required this.topProduct});

  @override
  List<Object?> get props => [topProduct];
}

class TopProductsPaginationDto extends Equatable {
  final int currentPage;
  final List<ProductDto> data;
  final String? firstPageUrl;
  final int from;
  final int lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  const TopProductsPaginationDto({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  @override
  List<Object?> get props => [
    currentPage,
    data,
    firstPageUrl,
    from,
    lastPage,
    lastPageUrl,
    nextPageUrl,
    path,
    perPage,
    prevPageUrl,
    to,
    total,
  ];
}

class TopProductsResponseDtoMapper extends FromJSONMapper<TopProductsResponseDto> {
  final ProductDtoMapper _productMapper = ProductDtoMapper();

  @override
  TopProductsResponseDto fromJSON(dynamic json) {
    return TopProductsResponseDto(
      status: parse<bool>(json['status']),
      data: TopProductsDataDto(
        topProduct: TopProductsPaginationDto(
          currentPage: parse<int>(json['data']['top_product']['current_page']),
          data: _productMapper.fromJSONList(json['data']['top_product']['data']),
          firstPageUrl: tryParse<String>(json['data']['top_product']['first_page_url']),
          from: parse<int>(json['data']['top_product']['from']),
          lastPage: parse<int>(json['data']['top_product']['last_page']),
          lastPageUrl: tryParse<String>(json['data']['top_product']['last_page_url']),
          nextPageUrl: tryParse<String>(json['data']['top_product']['next_page_url']),
          path: parse<String>(json['data']['top_product']['path']),
          perPage: parse<int>(json['data']['top_product']['per_page']),
          prevPageUrl: tryParse<String>(json['data']['top_product']['prev_page_url']),
          to: parse<int>(json['data']['top_product']['to']),
          total: parse<int>(json['data']['top_product']['total']),
        ),
      ),
      message: parse<String>(json['message']),
    );
  }
}
