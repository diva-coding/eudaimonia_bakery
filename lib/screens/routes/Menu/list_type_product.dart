import 'package:eudaimonia_bakery/screens/routes/Menu/detail_type.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final List<ProductType> productTypes = [
    ProductType(name: 'Electronics'),
    ProductType(name: 'Clothing'),
    ProductType(name: 'Groceries'),
    // Tambahkan tipe produk lainnya di sini
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 179, 126, 89),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Constants.secondaryColor,
        child: ListView.builder(
          itemCount: productTypes.length,
          itemBuilder: (context, index) {
            final productType = productTypes[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              child: ListTile(
                title: Text(productType.name, style: TextStyle(fontSize: 20)),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward, color: Constants.secondaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTypeScreen(productType: productType),
                      ),
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
}

class ProductType {
  final String name;

  ProductType({required this.name});
}