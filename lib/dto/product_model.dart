import 'package:intl/intl.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String imageUrl;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
      createdAt: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['created_at'] as String),
      updatedAt: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
         ? null
          : DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['deleted_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'category_id': categoryId,
      'created_at': DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(createdAt),
      'updated_at': DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(updatedAt),
      'deleted_at': deletedAt != null ? DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(deletedAt!) : null,
    };
  }
}
