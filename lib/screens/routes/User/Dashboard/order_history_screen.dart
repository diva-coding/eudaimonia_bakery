import 'package:eudaimonia_bakery/dto/order_model.dart';
import 'package:eudaimonia_bakery/services/order_data_service.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  Future<List<Order>>? _ordersFuture;
  int _userId = 0; 
  List<Order> _orders = []; // Combined list of all orders
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch user data when the screen initializes
  }
   
  Future<void> _loadUserData() async {
    try {
      final user = await DatabaseHelper.instance.getUser();
      setState(() {
        _userId = user!.userId;
        _ordersFuture = fetchOrders();
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading user data: $e";
      });
    }
  }

  void _navigateToOrderDetails(Order order) {
    Navigator.pushNamed(
      context,
      '/order-detail-history',
      arguments: order,
    );
  }


  Future<List<Order>> fetchOrders() async {
    return await OrderDataService.fetchOrderHistoryById(_userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Constants.secondaryColor,
      ),
      body: _errorMessage != null 
            ? Center(child: Text(_errorMessage!))  // Display error message if there was one
            : FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  _orders = snapshot.data!; // Update _orders with fetched data
                  return _buildOrderList(_orders); 
                } else {
                  return const Center(child: Text('No orders yet'));
                }
              },
            ),
      // ...
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Order #${order.orderId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(order.orderStatus != 'Finished')
            Text('Status: ${order.orderStatus}'),
            Text('Total: ${CurrencyUtils.formatToRupiah(order.totalPrice)}'),
            Text('Order By: ${order.userName}'),
            Text('Created At: ${DateFormat('yyyy-MM-dd HH:mm').format(order.createdAt)}'),
            Text('Updated At: ${DateFormat('yyyy-MM-dd HH:mm').format(order.updatedAt)}'),
            // Add more details as needed (e.g., order date, items)
          ],
        ),
        onTap: () {
          _navigateToOrderDetails(order);
        },
      ),
    );
  }
}