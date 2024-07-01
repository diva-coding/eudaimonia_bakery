import 'package:eudaimonia_bakery/dto/product_category_model.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key}); // Add Key constructor

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<ProductCategory> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchProductCategories();
  }

  Future<void> _fetchProductCategories() async {
    try {
      final categoriesData = await ProductDataService.fetchProductCategories();
      setState(() {
        categories = categoriesData
            .map((data) => ProductCategory.fromJson(data))
            .toList();
      });
    } catch (e) {
      _showErrorSnackBar('Error fetching product categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Products',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 126, 89),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Constants.secondaryColor,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              child: ListTile(
                title: Text(category.name, style: const TextStyle(fontSize: 20)),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Constants.secondaryColor),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/detail-category-screen',
                      arguments:
                          category, // Pass the CustomerServiceDatas object
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

