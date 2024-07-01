class Order {
  final int orderId;
  final int userId;
  String orderStatus;
  final int totalPrice;
  final String paymentMethod;
  final String userName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.userId,
    required this.orderStatus,
    required this.totalPrice,
    required this.paymentMethod,
    required this.userName,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: int.tryParse(json['order_id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      orderStatus: json['order_status'] ?? '',
      totalPrice: int.tryParse(json['total_price'].toString()) ?? 0,
      paymentMethod: json['payment_method'] ?? '',
      userName: json['user_name'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
      items: (json['items'] as List<dynamic>?)?.map((itemJson) => OrderItem.fromJson(itemJson)).toList() ?? [], // Ensure items is parsed as a list
    );
  }
}

class OrderItem {
  final int productId;
  final int quantity;
  final int price; // Add price for each item
  final String productName;


  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: int.tryParse(json['product_id'].toString()) ?? 0,
        quantity: json['quantity'],
        price: int.tryParse(json['price'].toString()) ?? 0,
        productName: json['product_name'] ?? '',
      );
}