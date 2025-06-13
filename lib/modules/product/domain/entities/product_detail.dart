import 'package:equatable/equatable.dart';

class ProductDetail extends Equatable {
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
  final String commonNames;
  final List<ProductIndustry> productIndustries;
  final String prodindName;
  final String categoryName;
  final List<RelatedProduct> relatedProducts;
  final BasicInfo basicInfo;

  const ProductDetail({
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
    required this.commonNames,
    required this.productIndustries,
    required this.prodindName,
    required this.categoryName,
    required this.relatedProducts,
    required this.basicInfo,
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
    commonNames,
    productIndustries,
    prodindName,
    categoryName,
    relatedProducts,
    basicInfo,
  ];

  @override
  String toString() {
    return 'ProductDetail(productName: $productName, casNumber: $casNumber)';
  }

  Map<String, dynamic> toJson() {
    return {
      'productImage': productImage,
      'productName': productName,
      'iupacName': iupacName,
      'casNumber': casNumber,
      'hsCode': hsCode,
      'formula': formula,
      'tdsFile': tdsFile,
      'msdsFile': msdsFile,
      'description': description,
      'application': application,
      'commonNames': commonNames,
      'productIndustries': productIndustries.map((e) => e.toJson()).toList(),
      'prodindName': prodindName,
      'categoryName': categoryName,
      'relatedProducts': relatedProducts.map((e) => e.toJson()).toList(),
      'basicInfo': basicInfo.toJson(),
    };
  }

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productImage: json['productImage'] as String,
      productName: json['productName'] as String,
      iupacName: json['iupacName'] as String,
      casNumber: json['casNumber'] as String,
      hsCode: json['hsCode'] as String,
      formula: json['formula'] as String,
      tdsFile: json['tdsFile'] as String,
      msdsFile: json['msdsFile'] as String,
      description: json['description'] as String,
      application: json['application'] as String,
      commonNames: json['commonNames'] as String,
      productIndustries:
          (json['productIndustries'] as List<dynamic>)
              .map((e) => ProductIndustry.fromJson(e as Map<String, dynamic>))
              .toList(),
      prodindName: json['prodindName'] as String,
      categoryName: json['categoryName'] as String,
      relatedProducts:
          (json['relatedProducts'] as List<dynamic>)
              .map((e) => RelatedProduct.fromJson(e as Map<String, dynamic>))
              .toList(),
      basicInfo: BasicInfo.fromJson(json['basicInfo'] as Map<String, dynamic>),
    );
  }
}

class ProductIndustry extends Equatable {
  final int id;
  final String prodindName;
  final String prodindDesc;
  final String prodindUrl;

  const ProductIndustry({
    required this.id,
    required this.prodindName,
    required this.prodindDesc,
    required this.prodindUrl,
  });

  @override
  List<Object?> get props => [id, prodindName, prodindDesc, prodindUrl];

  Map<String, dynamic> toJson() {
    return {'id': id, 'prodindName': prodindName, 'prodindDesc': prodindDesc, 'prodindUrl': prodindUrl};
  }

  factory ProductIndustry.fromJson(Map<String, dynamic> json) {
    return ProductIndustry(
      id: json['id'] as int,
      prodindName: json['prodindName'] as String,
      prodindDesc: json['prodindDesc'] as String,
      prodindUrl: json['prodindUrl'] as String,
    );
  }
}

class RelatedProduct extends Equatable {
  final int id;
  final String productImage;
  final String productName;
  final String casNumber;
  final String hsCode;
  final String formula;
  final String iupacName;

  const RelatedProduct({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productImage': productImage,
      'productName': productName,
      'casNumber': casNumber,
      'hsCode': hsCode,
      'formula': formula,
      'iupacName': iupacName,
    };
  }

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    return RelatedProduct(
      id: json['id'] as int,
      productImage: json['productImage'] as String,
      productName: json['productName'] as String,
      casNumber: json['casNumber'] as String,
      hsCode: json['hsCode'] as String,
      formula: json['formula'] as String,
      iupacName: json['iupacName'] as String,
    );
  }
}

class BasicInfo extends Equatable {
  final String phyAppearName;
  final String packagingName;
  final String commonNames;

  const BasicInfo({required this.phyAppearName, required this.packagingName, required this.commonNames});

  @override
  List<Object?> get props => [phyAppearName, packagingName, commonNames];

  Map<String, dynamic> toJson() {
    return {'phyAppearName': phyAppearName, 'packagingName': packagingName, 'commonNames': commonNames};
  }

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      phyAppearName: json['phyAppearName'] as String,
      packagingName: json['packagingName'] as String,
      commonNames: json['commonNames'] as String,
    );
  }
}
