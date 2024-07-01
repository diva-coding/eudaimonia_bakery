import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDetails = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${orderDetails['order_id']}'), // Display order ID
            Text('Order Status: ${orderDetails['status']}'), // Display order ID
            const SizedBox(height: 20),
            const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...(orderDetails['items'] as List<dynamic>).map((item) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      '${Endpoints.baseAPI}${item['image_url']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text('Product: ${item['status']}'),
                trailing: Text('${CurrencyUtils.formatToRupiah(item['price'])} x ${item['quantity']} = ${CurrencyUtils.formatToRupiah(item['price'] * item['quantity'])}'),
              );
            }),
            const SizedBox(height: 20),
            Text('Total Price: ${CurrencyUtils.formatToRupiah(orderDetails['total_price'])}'),
            const SizedBox(height: 20),
            Text('Payment Method: ${orderDetails['payment_method']}'),
            const SizedBox(height: 10),
            if (orderDetails['phone_number'] != null) // Check if phone number is available
              Text('Phone Number: ${orderDetails['phone_number']}'),
            const SizedBox(height: 20),
            Text('Shipping Address: ${orderDetails['shipping_address']}'),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Thank you for your order!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
