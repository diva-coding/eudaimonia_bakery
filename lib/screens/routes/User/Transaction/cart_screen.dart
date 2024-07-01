import 'package:eudaimonia_bakery/cubit/cart/cart_cubit.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(color: Constants.textColor, fontWeight: FontWeight.bold,),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 126, 89),
      ),
      backgroundColor: Constants.secondaryColor,
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final cartItems = state.cartItems;
            return cartItems.isEmpty
                ? const Center(child: Text('Shopping cart is empty'))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
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
                                  '${Endpoints.baseAPI}${cartItem.product.imageUrl}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(cartItem.product.name),
                            subtitle: Text(
                              'Price: ${CurrencyUtils.formatToRupiah(cartItem.product.price)} x ${cartItem.quantity} = ${CurrencyUtils.formatToRupiah(cartItem.totalPrice)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => context.read<CartCubit>().decreaseQuantity(cartItem),
                                ),
                                Text('${cartItem.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => context.read<CartCubit>().increaseQuantity(cartItem),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          } else {
            return const Center(child: Text('An error occurred'));
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.cartItems.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/checkout-screen',
                    arguments: state.cartItems, // Pass cartItems as arguments
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(color: Constants.primaryTextColor),
                ),
              ),
            );
          } else {
            return _buildEmptyCartMessage();
          }
        },
      ),
    );
  }

  Widget _buildEmptyCartMessage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
