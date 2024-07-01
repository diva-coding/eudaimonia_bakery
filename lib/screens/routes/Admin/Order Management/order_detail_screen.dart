import 'package:eudaimonia_bakery/dto/order_model.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Dashboard/admin_home_page.dart';
import 'package:eudaimonia_bakery/services/order_data_service.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDetailOrderScreen extends StatefulWidget {
  const AdminDetailOrderScreen({super.key});

  @override
  State<AdminDetailOrderScreen> createState() => _AdminDetailOrderScreenState();
}

class _AdminDetailOrderScreenState extends State<AdminDetailOrderScreen> {
  String? _selectedStatus; 
  bool _isLoading = false;
  final OrderDataService _orderDataService = OrderDataService();

  Future<void> _updateOrderStatus() async {
    setState(() => _isLoading = true);
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    bool success = await _orderDataService.updateOrderStatus(
      order.orderId,
      _selectedStatus!,
    );

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Order status updated successfully" : "Failed to update order status")),
    );

    if (success) {
      // Navigate back to the previous screen after successful update
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomePage(
                  initialIndex: 3), // Set initialIndex to 1 for Products tab
            ),
            (route) => false,
          );
    }
  }

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
            DropdownButtonFormField<String>(
              value: _selectedStatus, // Only show dropdown when a new status is selected
              hint: const Text('Select New Status'),
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
              items: ['Pending', 'Packing', 'Delivering', 'Arrived', 'Finished']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
            ),

            if (_selectedStatus != null) // Show button only when a new status is selected
              ElevatedButton(
                onPressed: _isLoading ? null : _updateOrderStatus,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Order Status'),
              ),
            // Add any other order details you want to display
          ],
        ),
      ),
    );
  }
}