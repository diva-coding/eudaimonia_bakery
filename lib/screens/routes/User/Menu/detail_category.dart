import 'package:eudaimonia_bakery/dto/product_category_model.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';

class DetailCategoryScreen extends StatefulWidget {

  const DetailCategoryScreen({super.key});

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  late Future<List<Product>> _products;
  ProductCategory? category;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)!.settings.arguments as ProductCategory;
    _products = ProductDataService.fetchProductsByCategory(category!.productCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as ProductCategory;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name, 
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 126, 89),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: _products, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); 
          } else if (snapshot.hasData) {
            final products = snapshot.data!; // No need to filter here

            return Container(
              color: Constants.secondaryColor,
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.6, 
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                      context,
                      '/detail-product-screen',
                      arguments:
                          product, // Pass the CustomerServiceDatas object
                      );
                    },
                   child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1 / 1, // Adjust the aspect ratio as needed
                            child: Image.network(
                              '${Endpoints.baseAPI}${product.imageUrl}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              CurrencyUtils.formatToRupiah(product.price),
                              style: const TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: const Icon(Icons.shopping_cart, color: Constants.secondaryColor),
                              onPressed: () {
                                // Add your onPressed logic here
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No products found.'));
          }
        },
      ),
    );
  }
}