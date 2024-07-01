class Product {
  final String image;
  final String title;
  final int price;
  final String? description;
  final int quantity;

  Product({required this.image, required this.title, required this.price, this.description, required this.quantity});
}