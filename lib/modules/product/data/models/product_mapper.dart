import 'package:trade_asia/modules/product/data/models/product_dto.dart';
import 'package:trade_asia/modules/product/data/models/product_detail_dto.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/domain/entities/product_detail.dart';

class ProductMapper {
  static Product fromDto(ProductDto dto) {
    return Product(
      id: dto.id,
      productImage: dto.productImage,
      productName: dto.productName,
      casNumber: dto.casNumber,
      iupacName: dto.iupacName,
      hsCode: dto.hsCode,
      formula: dto.formula,
      priority: dto.priority,
    );
  }

  static List<Product> fromDtoList(List<ProductDto> dtos) {
    return dtos.map((dto) => fromDto(dto)).toList();
  }
}

class ProductDetailMapper {
  static ProductDetail fromDto(ProductDetailDto dto, List<RelatedProductDto> relatedProducts, BasicInfoDto basicInfo) {
    return ProductDetail(
      productImage: dto.productImage,
      productName: dto.productName,
      iupacName: dto.iupacName,
      casNumber: dto.casNumber,
      hsCode: dto.hsCode,
      formula: dto.formula,
      tdsFile: dto.tdsFile,
      msdsFile: dto.msdsFile,
      description: dto.description,
      application: dto.application,
      commonNames: dto.commonNames,
      productIndustries:
          dto.productIndustries
              .map(
                (industry) => ProductIndustry(
                  id: industry.id,
                  prodindName: industry.prodindName,
                  prodindDesc: industry.prodindDesc,
                  prodindUrl: industry.prodindUrl,
                ),
              )
              .toList(),
      prodindName: dto.prodindName,
      categoryName: dto.categoryName,
      relatedProducts:
          relatedProducts
              .map(
                (related) => RelatedProduct(
                  id: related.id,
                  productImage: related.productImage,
                  productName: related.productName,
                  casNumber: related.casNumber,
                  hsCode: related.hsCode,
                  formula: related.formula,
                  iupacName: related.iupacName,
                ),
              )
              .toList(),
      basicInfo: BasicInfo(
        phyAppearName: basicInfo.phyAppearName,
        packagingName: basicInfo.packagingName,
        commonNames: basicInfo.commonNames,
      ),
    );
  }
}
