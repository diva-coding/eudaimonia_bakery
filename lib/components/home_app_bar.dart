import 'package:flutter/material.dart';
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          const Icon(
            Icons.sort,
            size: 30,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Eudaimonia Bakery", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)
              ),
            ),
          ),
          const Spacer(),
          Badge(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(7),
            child: InkWell(
              onTap: (){},
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          )
        ],
      ),
    );
  }
}