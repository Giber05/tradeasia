import 'package:equatable/equatable.dart';
import 'package:trade_asia/infrastructure/types/mapper/json_mapper.dart';

class ProductDetailDto extends Equatable {
  final String productImage;
  final String productName;
  final String iupacName;
  final String casNumber;
  final String hsCode;
  final String formula;
  final String tdsFile;
  final String msdsFile;
  final String description;
  final String application;
  final int phyAppearId;
  final String commonNames;
  final int prodindId;
  final int categoryId;
  final List<ProductIndustryDto> productIndustries;
  final String prodindName;
  final String categoryName;

  const ProductDetailDto({
    required this.productImage,
    required this.productName,
    required this.iupacName,
    required this.casNumber,
    required this.hsCode,
    required this.formula,
    required this.tdsFile,
    required this.msdsFile,
    required this.description,
    required this.application,
    required this.phyAppearId,
    required this.commonNames,
    required this.prodindId,
    required this.categoryId,
    required this.productIndustries,
    required this.prodindName,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [
    productImage,
    productName,
    iupacName,
    casNumber,
    hsCode,
    formula,
    tdsFile,
    msdsFile,
    description,
    application,
    phyAppearId,
    commonNames,
    prodindId,
    categoryId,
    productIndustries,
    prodindName,
    categoryName,
  ];
}

class ProductIndustryDto extends Equatable {
  final int id;
  final int prodindId;
  final int languageId;
  final String prodindName;
  final String prodindDesc;
  final String prodindUrl;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const ProductIndustryDto({
    required this.id,
    required this.prodindId,
    required this.languageId,
    required this.prodindName,
    required this.prodindDesc,
    required this.prodindUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    id,
    prodindId,
    languageId,
    prodindName,
    prodindDesc,
    prodindUrl,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

class RelatedProductDto extends Equatable {
  final int id;
  final String productImage;
  final String productName;
  final String casNumber;
  final String hsCode;
  final String formula;
  final String iupacName;

  const RelatedProductDto({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.casNumber,
    required this.hsCode,
    required this.formula,
    required this.iupacName,
  });

  @override
  List<Object?> get props => [id, productImage, productName, casNumber, hsCode, formula, iupacName];
}

class SalesAssociateInfoDto extends Equatable {
  final int? id;
  final String? cometChatUserId;

  const SalesAssociateInfoDto({this.id, this.cometChatUserId});

  @override
  List<Object?> get props => [id, cometChatUserId];
}

class BasicInfoDto extends Equatable {
  final String phyAppearName;
  final String packagingName;
  final String commonNames;

  const BasicInfoDto({required this.phyAppearName, required this.packagingName, required this.commonNames});

  @override
  List<Object?> get props => [phyAppearName, packagingName, commonNames];
}

class ProductDetailResponseDto extends Equatable {
  final bool status;
  final ProductDetailDataDto data;
  final String message;

  const ProductDetailResponseDto({required this.status, required this.data, required this.message});

  @override
  List<Object?> get props => [status, data, message];
}

class ProductDetailDataDto extends Equatable {
  final ProductDetailDto productDetail;
  final List<RelatedProductDto> relatedProduct;
  final SalesAssociateInfoDto salesAssociateInfo;
  final BasicInfoDto basicInfo;

  const ProductDetailDataDto({
    required this.productDetail,
    required this.relatedProduct,
    required this.salesAssociateInfo,
    required this.basicInfo,
  });

  @override
  List<Object?> get props => [productDetail, relatedProduct, salesAssociateInfo, basicInfo];
}

class ProductIndustryDtoMapper extends FromJSONMapper<ProductIndustryDto> {
  @override
  ProductIndustryDto fromJSON(dynamic json) {
    return ProductIndustryDto(
      id: parse<int>(json['id']),
      prodindId: parse<int>(json['prodind_id']),
      languageId: parse<int>(json['language_id']),
      prodindName: parse<String>(json['prodind_name'] ?? ''),
      prodindDesc: parse<String>(json['prodind_desc'] ?? ''),
      prodindUrl: parse<String>(json['prodind_url'] ?? ''),
      createdAt: parse<String>(json['created_at'] ?? ''),
      updatedAt: parse<String>(json['updated_at'] ?? ''),
      deletedAt: tryParse<String>(json['deleted_at']),
    );
  }
}

class RelatedProductDtoMapper extends FromJSONMapper<RelatedProductDto> {
  @override
  RelatedProductDto fromJSON(dynamic json) {
    return RelatedProductDto(
      id: parse<int>(json['id']),
      productImage: parse<String>(json['productimage'] ?? ''),
      productName: parse<String>(json['productname'] ?? ''),
      casNumber: parse<String>(json['cas_number'] ?? ''),
      hsCode: parse<String>(json['hs_code'] ?? ''),
      formula: parse<String>(json['formula'] ?? ''),
      iupacName: parse<String>(json['iupac_name'] ?? ''),
    );
  }
}

class ProductDetailDtoMapper extends FromJSONMapper<ProductDetailDto> {
  final ProductIndustryDtoMapper _industryMapper = ProductIndustryDtoMapper();

  @override
  ProductDetailDto fromJSON(dynamic json) {
    return ProductDetailDto(
      productImage: parse<String>(json['productimage'] ?? ''),
      productName: parse<String>(json['productname'] ?? ''),
      iupacName: parse<String>(json['iupac_name'] ?? ''),
      casNumber: parse<String>(json['cas_number'] ?? ''),
      hsCode: parse<String>(json['hs_code'] ?? ''),
      formula: parse<String>(json['formula'] ?? ''),
      tdsFile: parse<String>(json['tds_file'] ?? ''),
      msdsFile: parse<String>(json['msds_file'] ?? ''),
      description: parse<String>(json['description'] ?? ''),
      application: parse<String>(json['application'] ?? ''),
      phyAppearId: parse<int>(json['phy_appear_id'] ?? 0),
      commonNames: parse<String>(json['common_names'] ?? ''),
      prodindId: parse<int>(json['prodind_id'] ?? 0),
      categoryId: parse<int>(json['category_id'] ?? 0),
      productIndustries: _industryMapper.fromJSONList(json['productIndustries'] ?? []),
      prodindName: parse<String>(json['prodind_name'] ?? ''),
      categoryName: parse<String>(json['category_name'] ?? ''),
    );
  }
}

class ProductDetailResponseDtoMapper extends FromJSONMapper<ProductDetailResponseDto> {
  final ProductDetailDtoMapper _productDetailMapper = ProductDetailDtoMapper();
  final RelatedProductDtoMapper _relatedProductMapper = RelatedProductDtoMapper();

  @override
  ProductDetailResponseDto fromJSON(dynamic json) {
    return ProductDetailResponseDto(
      status: parse<bool>(json['status']),
      data: ProductDetailDataDto(
        productDetail: _productDetailMapper.fromJSON(json['data']['product_detail']),
        relatedProduct: _relatedProductMapper.fromJSONList(json['data']['related_product'] ?? []),
        salesAssociateInfo: SalesAssociateInfoDto(
          id: tryParse<int>(json['data']['sales_associate_info']['id']),
          cometChatUserId: tryParse<String>(json['data']['sales_associate_info']['comet_chat_user_id']),
        ),
        basicInfo: BasicInfoDto(
          phyAppearName: parse<String>(json['data']['basic_info']['phy_appear_name'] ?? ''),
          packagingName: parse<String>(json['data']['basic_info']['packaging_name'] ?? ''),
          commonNames: parse<String>(json['data']['basic_info']['common_names'] ?? ''),
        ),
      ),
      message: parse<String>(json['message']),
    );
  }
}
