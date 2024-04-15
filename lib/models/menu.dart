class Menu {
  int? id;
  late String title, description;
  late int price;

  Menu({
    this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
