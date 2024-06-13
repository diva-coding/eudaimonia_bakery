import 'package:eudaimonia_bakery/dto/product.dart';
import 'package:eudaimonia_bakery/screens/routes/Menu/detail_product.dart';
import 'package:eudaimonia_bakery/screens/routes/Menu/list_type_product.dart';// Import ProductDetailScreen
import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';

class DetailTypeScreen extends StatelessWidget {
  final ProductType productType;

  DetailTypeScreen({required this.productType});

  final List<Product> products = [
    Product(image: 'assets/images/background.png', title: 'Product 1', price: 29.99),
    Product(image: 'assets/images/background.png', title: 'Product 2', price: 49.99),
    Product(image: 'assets/images/background.png', title: 'Product 3', price: 19.99),
    // Tambahkan produk lainnya di sini
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productType.name,
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 179, 126, 89),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Constants.secondaryColor,
        padding: EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Menampilkan 2 kolom per baris
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.6, // Rasio aspek dari setiap kartu
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Mengatur sudut melengkung
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(product.image, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(product.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('\$${product.price}', style: TextStyle(fontSize: 14, color: Colors.green)),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart, color: Constants.secondaryColor),
                          onPressed: () {
                            // Logika untuk menambahkan ke keranjang
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
