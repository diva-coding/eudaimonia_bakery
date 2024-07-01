import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ProductSearchScreenState createState() => ProductSearchScreenState();
}

class ProductSearchScreenState extends State<ProductSearchScreen> {
  late Future<List<Product>> _products;
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _sortCriteria = 'name';
  bool _sortAscending = true; // Added for ascending/descending toggle
  int _currentPage = 1;
  final int _productsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    _products = ProductDataService.fetchProducts();
    await _products.then((products) {
      setState(() {
        _filteredProducts = products;
      });
    });
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _sortProducts(String criteria) {
    setState(() {
      if (_sortCriteria == criteria) {
        _sortAscending = !_sortAscending; // Toggle ascending/descending if same criteria
      } else {
        _sortAscending = true; // Default to ascending when changing criteria
      }
      _sortCriteria = criteria;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _products.then((products) {
      List<Product> filtered = products.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      switch (_sortCriteria) {
        case 'name':
          filtered.sort((a, b) => _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
          break;
        case 'price':
          filtered.sort((a, b) => _sortAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
          break;
        case 'date':
          filtered.sort((a, b) => _sortAscending ? a.updatedAt.compareTo(b.updatedAt) : b.updatedAt.compareTo(a.updatedAt));
          break;
      }

      setState(() {
        _filteredProducts = filtered;
        _currentPage = 1;
      });
    });
  }

  List<Product> _getCurrentPageProducts() {
    int startIndex = (_currentPage - 1) * _productsPerPage;
    int endIndex = startIndex + _productsPerPage;
    return _filteredProducts.sublist(
      startIndex,
      endIndex > _filteredProducts.length ? _filteredProducts.length : endIndex,
    );
  }

  void _nextPage() {
    if (_currentPage * _productsPerPage < _filteredProducts.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _refreshProducts() async {
    await _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.secondaryColor,
      ),
      backgroundColor: Constants.secondaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchProducts,
              decoration: const InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: _sortCriteria,
                onChanged: (value) {
                  if (value != null) {
                    _sortProducts(value);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'name',
                    child: Text('Sort by Name'),
                  ),
                  DropdownMenuItem(
                    value: 'price',
                    child: Text('Sort by Price'),
                  ),
                  DropdownMenuItem(
                    value: 'date',
                    child: Text('Sort by Date'),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _sortAscending = !_sortAscending;
                    _applyFilters();
                  });
                },
                icon: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child: FutureBuilder<List<Product>>(
                future: _products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final products = _getCurrentPageProducts();
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    '${Endpoints.baseAPI}${product.imageUrl}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(product.description),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(CurrencyUtils.formatToRupiah(product.price)),
                                  Text("Stock: ${product.stock}"),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail-product-screen',
                                  arguments: product,
                                );
                              },
                            ),
                          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _previousPage,
                child: const Text(
                  'Previous',
                  style: TextStyle(color: Constants.textColor),
                ),
              ),
              Text('Page $_currentPage', style: const TextStyle(color: Constants.textColor, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: _nextPage,
                child: const Text('Next', style: TextStyle(color: Constants.textColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
