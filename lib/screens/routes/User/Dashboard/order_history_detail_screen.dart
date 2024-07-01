import 'package:eudaimonia_bakery/dto/order_model.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details #${order.orderId}'),
      ),
      body: SingleChildScrollView( // Make the content scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.orderId}'),
            Text('Customer: ${order.userName}'),
            Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(order.createdAt)}'),
            Text('Total Price: ${CurrencyUtils.formatToRupiah(order.totalPrice)}'),
            Text('Payment Method: ${order.paymentMethod}'),
            Text('Status: ${order.orderStatus}'),
            const SizedBox(height: 20),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...order.items.map(
              (item) => ListTile(
                title: Text(item.productName), // Null check for product name
                trailing: Text('${CurrencyUtils.formatToRupiah(item.price)} x ${item.quantity}'),
              ),
            ),
            // Add any other order details you want to display
          ],
        ),
      ),
    );
  }
}