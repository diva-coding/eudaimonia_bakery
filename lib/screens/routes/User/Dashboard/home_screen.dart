import 'package:cached_network_image/cached_network_image.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> bestSellers;
  late Future<List<Product>> recommended;
  late Future<List<Product>> newProducts;

  @override
  void initState() {
    super.initState();
    bestSellers = ProductDataService.fetchProductsByCategory(1); // Example category ID for best sellers
    recommended = ProductDataService.fetchProductsByCategory(2); // Example category ID for recommended products
    newProducts = ProductDataService.fetchProductsByCategory(3); // Example category ID for new products
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 1000,
          child: Stack(
            children: [
              Container(
                height: 250,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  image: DecorationImage(
                    image: const AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.55), BlendMode.darken),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: const BoxDecoration(

                      ),
                      child: const Row(
                        children: [

                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: const Column(
                        children: [
                          Text(
                            "Hello!",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Constants.primaryColor,
                            ),
                          ),
                          Text(
                            "What do you want to eat today?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 200,
                right: 0,
                left: 0,
                child: Container(
                  height: 1500,
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Constants.secondaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15, left: 10),
                        child: Text(
                          "Best Seller This Week!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Constants.textColor
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 0, left: 10),
                        child: Text(
                          'Here is the best selling product this week...',
                          style: TextStyle(
                            color: Constants.textColor
                          ),
                        ),
                      ),
                      FutureBuilder<List<Product>>(
                        future: bestSellers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: snapshot.data!.map((product) {
                                  return ProductCard(
                                    product: product,
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'Recommended For You',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Constants.textColor
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 0, left: 10),
                        child: Text(
                          'Maybe you would like this...',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      FutureBuilder<List<Product>>(
                        future: recommended,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: snapshot.data!.map((product) {
                                  return ProductCard(
                                    product: product,
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          'New Product',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 0, left: 10),
                        child: Text(
                          'Recently added product you should try...',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      FutureBuilder<List<Product>>(
                        future: newProducts,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: snapshot.data!.map((product) {
                                  return ProductCard(
                                    product: product,
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail-product-screen',
          arguments: product,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 250,
          height: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(223, 87, 87, 87).withOpacity(0.75),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 0),
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: '${Endpoints.baseAPI}${product.imageUrl}',
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: 145,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Text(product.name),
            ],
          ),
        ),
      ),
    );
  }
}