import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String productImage;
  final String productName;
  final String casNumber;
  final String iupacName;
  final String hsCode;
  final String formula;
  final int priority;

  const Product({
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

  @override
  String toString() {
    return 'Product(id: $id, productName: $productName, casNumber: $casNumber)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productImage': productImage,
      'productName': productName,
      'casNumber': casNumber,
      'iupacName': iupacName,
      'hsCode': hsCode,
      'formula': formula,
      'priority': priority,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      productImage: json['productImage'] as String,
      productName: json['productName'] as String,
      casNumber: json['casNumber'] as String,
      iupacName: json['iupacName'] as String,
      hsCode: json['hsCode'] as String,
      formula: json['formula'] as String,
      priority: json['priority'] as int,
    );
  }
}
