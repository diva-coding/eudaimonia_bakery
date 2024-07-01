import 'dart:convert';

import 'package:eudaimonia_bakery/dto/order_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

class OrderDataService {
  final String baseUrl = 'http://your_flask_api_url'; // Replace with your actual API URL

  Future<Map<String, dynamic>?> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.orderCreate),
        body: jsonEncode(orderData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData; // Return the order details from the API
      } else {
        // Handle error responses from the API
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error placing order: $error');
      throw Exception('An error occurred while placing the order');
    }
  }

  static Future<List<Order>> fetchOrderHistoryById(int userId) async {
    try {
      final response = await http.get(Uri.parse('${Endpoints.getOrders}/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((orderJson) => Order.fromJson(orderJson)).toList();
      } else {
        throw Exception('Failed to load order history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging
      print('Error loading order history: $e');

      // Return an empty list to prevent the app from crashing
      return []; 
    }
  }

    static Future<List<Order>> fetchOrderHistory() async {
    try {
      final response = await http.get(Uri.parse(Endpoints.getOrders));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((orderJson) => Order.fromJson(orderJson)).toList();
      } else {
        throw Exception('Failed to load order history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging
      print('Error loading order history: $e');

      // Return an empty list to prevent the app from crashing
      return []; 
    }
  }

    Future<bool> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse('${Endpoints.orderStatusChange}/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'order_status': newStatus}),
      );

      return response.statusCode == 200; // Return true on success, false otherwise
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }
}