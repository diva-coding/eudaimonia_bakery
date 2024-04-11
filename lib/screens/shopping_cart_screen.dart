import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<Map<String, dynamic>> _cartItems = [
    {'name': 'Cromboloni', 'image': 'assets/images/cromboloni.jpg', 'quantity': 1},
    {'name': 'Brownies', 'image': 'assets/images/brownies.jpg', 'quantity': 1},
    {'name': 'Choco Puff Pastry', 'image': 'assets/images/puffpastry.jpeg', 'quantity': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 179, 126, 89),
      appBar: AppBar(
        title: Text('Shopping Cart', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset(
                _cartItems[index]['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(_cartItems[index]['name']),
              subtitle: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      _decrementQuantity(index);
                    },
                  ),
                  Text(_cartItems[index]['quantity'].toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _incrementQuantity(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Tambahkan logika untuk proses checkout
        },
        label: Text('Checkout'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      }
    });
  }
}