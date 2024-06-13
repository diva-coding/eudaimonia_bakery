import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 1000,
          child: Stack(
            children: [
              Container(
                // temporary height
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
                        color: Constants.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            height: 50,
                            width: 300,
                            child: TextFormField(
                              autocorrect: false,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search here..."),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.search),
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
                            "Mau makan apa hari ini?",
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
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Constants.secondaryColor,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 10),
                        child: Text(
                          'Here is the best selling product this week...',
                          style: TextStyle(
                            color: Constants.textColor
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BestSellerCard(
                                title: "Cromboloni", path: "assets/images/cromboloni.jpg"),
                            BestSellerCard(
                                title: "Choco Brownies", path: "assets/images/brownies.jpg"),
                            BestSellerCard(
                                title: "Eudaimonia Original Bread", path: "assets/images/eudaimonia_bread.jpg"),
                            BestSellerCard(
                                title: "Cheesecake", path: "assets/images/cheesecake.jpg"),
                            BestSellerCard(
                                title: "Croissant", path: "assets/images/hero.jpg"),
                          ],
                        ),
                      ),
                      Padding(
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
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 10),
                        child: Text(
                          'Maybe you would like this...',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BestSellerCard(
                                title: "Choco Puff Pastry", path: "assets/images/puffpastry.jpeg"),
                            BestSellerCard(
                                title: "Cupcakes", path: "assets/images/cupcakes.jpg"),
                            BestSellerCard(
                                title: "Apple Pie", path: "assets/images/Apple-Pie.jpg"),
                          ],
                        ),
                      ),
                      Padding(
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
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 10),
                        child: Text(
                          'Recently added product you should try...',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BestSellerCard(
                                title: "Choux Pastry", path: "assets/images/choux.jpg"),
                            BestSellerCard(
                                title: "Apple Pie", path: "assets/images/Apple-Pie.jpg"),
                            BestSellerCard(
                                title: "Chocolate Bread", path: "assets/images/chocolate_bread.jpeg"),
                          ],
                        ),
                      )
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

class BestSellerCard extends StatelessWidget {
  final String title;
  final String path;
  const BestSellerCard({super.key, required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        height: 170,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    Color.fromARGB(223, 87, 87, 87).withOpacity(0.75),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Container(
              width: 250,
              height: 145,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(path),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}