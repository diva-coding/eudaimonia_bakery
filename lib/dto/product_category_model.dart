import 'package:intl/intl.dart';

class ProductCategory{
  final int productCategoryId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  ProductCategory({
    required this.productCategoryId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      productCategoryId: json['product_category_id'],
      name: json['name'],
      createdAt: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['created_at'] as String),
      updatedAt: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
         ? null
          : DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['deleted_at'] as String),
    );
  } 
}