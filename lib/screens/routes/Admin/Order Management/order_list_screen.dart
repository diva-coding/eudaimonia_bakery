import 'package:eudaimonia_bakery/dto/order_model.dart';
import 'package:eudaimonia_bakery/services/order_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  Future<List<Order>>? _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  void _navigateToOrderDetails(Order order) {
    Navigator.pushNamed(
      context,
      '/admin-order-detail-screen',
      arguments: order,
    );
  }

  Future<List<Order>> fetchOrders() async {
    return await OrderDataService.fetchOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              labelColor: Constants.secondaryColor,
              indicatorColor: Constants.secondaryColor,
              tabs: [
                Tab(text: "Pending"),
                Tab(text: "Packing"),
                Tab(text: "Delivering"),
                Tab(text: "Arrived"),
                Tab(text: "Finished"),
              ],
            ),
            title: const Text('Order Lists'),
          ),
          body: FutureBuilder<List<Order>>(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final orders = snapshot.data!; // Get the orders from the future
                return TabBarView(
                  children: [
                    _buildOrderList(orders
                        .where((order) => order.orderStatus == 'Pending')
                        .toList(), "Pending"),
                    _buildOrderList(orders
                        .where((order) => order.orderStatus == 'Packing')
                        .toList(), "Packing"),
                    _buildOrderList(orders
                        .where((order) => order.orderStatus == 'Delivering')
                        .toList(), "Delivering"),
                    _buildOrderList(orders
                        .where((order) => order.orderStatus == 'Arrived')
                        .toList(), "Arrived"),
                    _buildOrderList(orders
                        .where((order) => order.orderStatus == 'Finished')
                        .toList(), "Finished"),
                  ],
                );
              } else {
                return const Center(child: Text('No orders yet'));
              }
            },
          ),
        ),
      ),
    );
  }

Widget _buildOrderList(List<Order> orders, String orderStatus) {
  if (orders.isEmpty) {
    return Center(
      child: Text(
        "No orders with status '$orderStatus'", 
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  } else {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderItem(order);
      },
    );
  }
}

  Widget _buildOrderItem(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Order #${order.orderId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (order.orderStatus != 'Finished')
              Text('Status: ${order.orderStatus}'),
            Text('Total: ${CurrencyUtils.formatToRupiah(order.totalPrice)}'),
            Text('Order By: ${order.userName}'),
            Text(
                'Created At: ${DateFormat('yyyy-MM-dd HH:mm').format(order.createdAt)}'),
            Text(
                'Updated At: ${DateFormat('yyyy-MM-dd HH:mm').format(order.updatedAt)}'),
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
