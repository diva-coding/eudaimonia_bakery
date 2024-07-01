import 'dart:convert';

import 'package:eudaimonia_bakery/dto/product_category_model.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

class ProductDataService {
  // Replace with your API base URL
// ! PRODUCT SECTION
  // * get product
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('${Endpoints.products}/read'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

  // * post product
  static Future<http.Response> createProductWithImage(int spending) async {
    final url = Uri.parse('${Endpoints.products}/create');
    final data = {'spending': spending};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  // * delete product data
  static Future<void> deleteProductData(int id) async {
    final response =
        await http.get(Uri.parse('${Endpoints.productDelete}/$id'));

    if (response.statusCode == 200) {
      // Deletion successful
    } else {
      throw Exception('Failed to delete data');
    }
  }

  // * get product category list data
  static Future<List<ProductCategory>> fetchProductCategory() async {
    final response = await http.get(Uri.parse(Endpoints.productCategoryDatas));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => ProductCategory.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

  // * get product category data by category id
  static Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${Endpoints.productCategoryDatas}/$categoryId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['category'];
      } else if (response.statusCode == 404) {
        // Category not found
        return null;
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error fetching category: $e');
      return null;
    }
  }

// ! PRODUCT CATEGORY SECTION

  static Future<List<Map<String, dynamic>>> fetchProductCategories() async {
    try {
      final response =
          await http.get(Uri.parse(Endpoints.productCategoryDatas));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            jsonDecode(response.body)['datas']);
      } else {
        throw Exception(
            'Failed to load product categories (Error ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching product categories: $e');
    }
  }

  static Future<void> addProductCategory(String name) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.productCategoryCreate),
        body: {'name': name},
      );
      if (response.statusCode != 201) {
        throw Exception(
            'Failed to add product category (Error ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error adding product category: $e');
    }
  }

  static Future<void> updateProductCategory(int id, String newName) async {
    try {
      final response = await http.put(
        Uri.parse('${Endpoints.productCategoryUpdate}/$id'),
        body: {'name': newName},
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update product category (Error ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error updating product category: $e');
    }
  }

  static Future<void> deleteProductCategory(int id) async {
    try {
      final response =
          await http.get(Uri.parse('${Endpoints.productCategoryDelete}/$id'));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete product category (Error ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error deleting product category: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProductsForCategory(
      int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.productDataByCategory),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedBody =
            jsonDecode(response.body); // Decode response body first

        if (decodedBody.containsKey('datas') && decodedBody['datas'] != null) {
          final List<dynamic> data = decodedBody['datas'];
          return List<Map<String, dynamic>>.from(data);
        } else {
          return []; // Return an empty list if 'datas' is missing or null
        }
      } else {
        throw Exception(
            'Failed to load products for category (Error ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching products for category: $e');
    }
  }

  static Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(Uri.parse('${Endpoints.userProductsByCategory}/$categoryId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products for category $categoryId');
      }
    } catch (e) {
      throw Exception('Error loading products for category $categoryId: $e');
    }
  }
}
