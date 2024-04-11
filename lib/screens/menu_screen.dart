import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('All Products',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            backgroundColor: Color.fromARGB(255, 179, 126, 89)),
        backgroundColor: Color.fromARGB(255, 179, 126, 89),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Bread',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const ProductCard(
              menu: 'Eudaimonia Original Bread',
              image: 'assets/images/eudaimonia_bread.jpg',
              description: "Unique sourdough bread with rosemary and sea salt flavor.",
            ),
            const ProductCard(
              menu: 'Wheat Bread',
              image: 'assets/images/wheat_bread.jpeg',
              description: 'Whole wheat bread, freshly baked with a wholesome taste and hearty texture.',
            ),
            ProductCard(
              menu: 'Chocolate Bread', 
              image: 'assets/images/chocolate_bread.jpeg', 
              description: 'Chocolate-flavored flat bread, a delightful twist on classic bread.'
              ),
          Text('   Pastry', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          )),
          ProductCard(
            menu: 'Cromboloni', 
            image: 'assets/images/cromboloni.jpg', 
            description: 'Italian-style stuffed pastry filled with a delicious blend of sweet or savory fillings, perfect for any craving.'
          ),
          ProductCard(
            menu: 'Croissant', 
            image: 'assets/images/hero.jpg', 
            description: 'Flaky croissant, buttery and light, perfect for breakfast or a delightful snack.'
          ),
          
          ],
        
          
        ));
  }
}

class ProductCard extends StatelessWidget {
  final String menu;
  final String image;
  final String description;
  const ProductCard(
      {super.key,
      required this.menu,
      required this.image,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 10),
      height: 185.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(menu,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(description),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 120,
                height: 120,
                child: Image.asset(image, fit: BoxFit.cover),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    child: Text(
                      'Add',
                      style:
                          TextStyle(color: Color.fromARGB(255, 179, 126, 89)),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromARGB(255, 179, 126, 89),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
