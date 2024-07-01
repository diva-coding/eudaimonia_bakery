import 'package:eudaimonia_bakery/cubit/cart/cart_cubit.dart';
import 'package:eudaimonia_bakery/dto/cart_item_model.dart';
import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/services/order_data_service.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'DANA'; // Default payment method
  final _phoneNumberController = TextEditingController();
  User user = User(userId: 0, name: "", email: "", role: "", phoneNumber: "", address: "", createdAt: DateTime.now(), updatedAt: DateTime.now());
  bool _isLoading = true;
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments; 
    if (arguments is List<CartItem>) {
      setState(() {
        cartItems = arguments;
      });
    }
  }

  Future<void> _getUserData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      user = User(userId: 1, name: "user name", email: "user@email.com", role: "user", phoneNumber: "0823823823", address: "Jl. Address", createdAt: DateTime.now(), updatedAt: DateTime.now());
      _isLoading = false;
    });
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final paymentMethod = _selectedPaymentMethod;
    String? phoneNumber;
    if (paymentMethod == 'DANA' || paymentMethod == 'OVO') {
      phoneNumber = _phoneNumberController.text;
    }

    final user = await DatabaseHelper.instance.getUser();
    final order = {
      'total_price': cartItems.fold(0, (sum, item) => sum + item.totalPrice),
      'items': cartItems.map((item) => {
        'product_id': item.product.id,
        'name': item.product.name,
        'price': item.product.price,
        'quantity': item.quantity,
        'imageUrl': item.product.imageUrl,
        'shipping_address': user!.address,
      }).toList(),
      'user_id': user!.userId,
      'payment_method': paymentMethod,
      'order_status': 'Pending',
      'phone_number': phoneNumber,
      'shipping_address': user.address,
    };

    try {
      final OrderDataService orderService = OrderDataService();
      final responseData = await orderService.placeOrder(order);

      if (responseData != null && responseData['status'] == 'success') {
        context.read<CartCubit>().clearCart();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success")));
        Navigator.pushReplacementNamed(context, '/order-confirmation', arguments: responseData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to create order")));
      }

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...cartItems.map((cartItem) {
                  return ListTile(
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
                    trailing: Text(
                        '${CurrencyUtils.formatToRupiah(cartItem.product.price)} x ${cartItem.quantity} = ${CurrencyUtils.formatToRupiah(cartItem.totalPrice)}'),
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  items: const [
                    DropdownMenuItem(value: 'DANA', child: Text('DANA')),
                    DropdownMenuItem(value: 'OVO', child: Text('OVO')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Payment Method',
                  ),
                ),
                if (_selectedPaymentMethod == 'DANA' || _selectedPaymentMethod == 'OVO')
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _placeOrder();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.secondaryColor,
                  ),
                  child: const Text('Place Order', style: TextStyle(color: Constants.textColor,),)
                ),
              ],
            ),
          ),
        ),
    );
  }
}
