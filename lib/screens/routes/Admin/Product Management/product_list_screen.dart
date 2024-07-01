import 'package:cached_network_image/cached_network_image.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Product%20Management/product_create_screen.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _filteredProducts = [];
  bool _isAscending = true;
  bool _isMultiSelect = false;
  late Future<List<Product>> _products;
  String _searchQuery = '';
  int? _selectedCategoryId;
  final List<Product> _selectedProducts = [];
  String _sortBy = 'Name';
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await ProductDataService.fetchProducts();
    setState(() {
      _products = Future.value(products);
      _filteredProducts = products;
    });
  }

  void _filterProducts() {
    _products.then((products) {
      setState(() {
        _filteredProducts = products
            .where((product) =>
                product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
        
        // Check if search query is empty, then show all products
        if (_searchQuery.isEmpty) {
          _filteredProducts = products;
        }
      });
    }).catchError((error) {
      print('Error fetching products: $error');
    });
  }

  void _sortProducts() {
    setState(() {
      if (_sortBy == 'Name') {
        _filteredProducts.sort((a, b) => _isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
      } else if (_sortBy == 'Date') {
        _filteredProducts.sort((a, b) => _isAscending ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt));
      }
    });
  }

  void _toggleSelect(Product product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
      _isMultiSelect = _selectedProducts.isNotEmpty;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProducts.clear();
      _isMultiSelect = false;
    });
  }

  void _deleteSelectedProducts() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${_selectedProducts.length} selected product(s)?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performDelete();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete() async {
    setState(() {
      _isDeleting = true; // Show loading indicator
    });

    try {
      // Simulate deletion delay (replace with actual deletion logic)
      await Future.delayed(const Duration(seconds: 2));

      // Delete selected products from data service
      await Future.forEach(_selectedProducts, (product) async {
        await ProductDataService.deleteProductData(product.id);
        _filteredProducts.remove(product);
      });

      setState(() {
        _clearSelection(); // Clear selection after deletion
        _isDeleting = false; // Hide loading indicator
      });

      // Refresh product list
      _fetchProducts();
    } catch (e) {
      print('Error deleting products: $e');
      setState(() {
        _isDeleting = false; // Hide loading indicator on error
      });
    }
  }

  void _moveSelectedProductsToCategory(int categoryId) {
    // Add logic to move selected products to a specific category
    // For now, just clear the selection
    setState(() {
      _clearSelection();
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _filterProducts();
          });
        },
      ),
    );
  }

  Widget _buildSortAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: _sortBy,
            items: <String>['Name', 'Date'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _sortBy = newValue!;
                _sortProducts();
              });
            },
          ),
          IconButton(
            icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
                _sortProducts();
              });
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _getCategoryDropdownItems() {
    // Replace with actual category items
    return [
      const DropdownMenuItem<int>(
        value: 1,
        child: Text('Category 1'),
      ),
      const DropdownMenuItem<int>(
        value: 2,
        child: Text('Category 2'),
      ),
      // Add more categories here
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        actions: _isMultiSelect
            ? [
                Text('${_selectedProducts.length} selected'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSelection,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelectedProducts,
                ),
                IconButton(
                  icon: const Icon(Icons.folder),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Move to Category'),
                          content: DropdownButtonFormField<int>(
                            value: _selectedCategoryId,
                            items: _getCategoryDropdownItems(),
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedCategoryId = newValue;
                              });
                            },
                            decoration: const InputDecoration(labelText: 'Category'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _moveSelectedProductsToCategory(_selectedCategoryId!);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Move'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(),
              _buildSortAndFilterBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchProducts,
                  child: FutureBuilder<List<Product>>(
                    future: _products,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final products = _filteredProducts;
                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                                child: SizedBox(
                                  width: 50, // Fixed width
                                  height: 50, // Fixed height
                                  child: CachedNetworkImage(
                                    imageUrl: '${Endpoints.baseAPI}${product.imageUrl}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(product.name),
                              subtitle: Text(product.description),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end, // Align items to the end (right)
                                mainAxisSize: MainAxisSize.min, // Let the column take the minimum space
                                children: [
                                  Text(CurrencyUtils.formatToRupiah(product.price)), // Formatted price
                                  Text("Stock: ${product.stock}"), // Display stock quantity
                                ],
                              ),
                              onTap: () {
                                if (_isMultiSelect) {
                                  _toggleSelect(product);
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    '/admin-product-detail-screen',
                                    arguments: product,
                                  );
                                }
                              },
                              onLongPress: () {
                                _toggleSelect(product);
                              },
                              selected: _selectedProducts.contains(product),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text("No products found."));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}