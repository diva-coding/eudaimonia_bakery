import 'package:cached_network_image/cached_network_image.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Future<String> _getCategoryName(int categoryId) async {
    try {
      final categoryData = await ProductDataService.getCategoryById(categoryId);
      if (categoryData != null) {
        return categoryData['name'];
      } else {
        return "Unknown Category"; // Category not found
      }
    } catch (e) {
      // Handle error (e.g., network error)
      print('Error fetching category name: $e');
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    var logger = Logger();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Detail"),
          backgroundColor: Constants.secondaryColor,
          actions: [
            // Add 'actions' for buttons
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/admin-product-update-screen',
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Delete Functionality (with a confirmation dialog)
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to delete this item?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.pop(ctx), // Close dialog
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () async {
                          // Make the call asynchronous
                          try {
                            await ProductDataService.deleteProductData(
                                product.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Product deleted successfully')),
                              );
                              Navigator.pop(ctx); // Close dialog
                              Navigator.pushReplacementNamed(
                                  context, '/admin-product-lists-screen');
                            }
                          } catch (error) {
                            // Handle the error (e.g., display an error message)
                            logger.e(error);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              // Add a Card for structure
              child: Padding(
                // Introduce internal padding
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      // Keep the image centered
                      child: ClipRRect(
                        // Rounded corners
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: '${Endpoints.baseAPI}${product.imageUrl}',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: 250,
                          width: double.infinity, // Occupy card width
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Category: ',
                          style: TextStyle(fontSize: 14),
                        ),
                        FutureBuilder<String>(
                          future: _getCategoryName(product.categoryId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width:
                                    16, // Add some spacing for the CircularProgressIndicator
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, // Make the indicator smaller
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(snapshot.data!);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: ${CurrencyUtils.formatToRupiah(product.price)}',
                      style: const TextStyle(fontSize: 14),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stock: ${product.stock}',
                      style: const TextStyle(fontSize: 14),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date Created: ${DateFormat('MMMM dd, yyyy hh:mm:ss a').format(product.createdAt)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    Text(
                      'Date Updated: ${DateFormat('MMMM dd, yyyy hh:mm:ss a').format(product.updatedAt)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4, // Adjust line height here
                      ),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
