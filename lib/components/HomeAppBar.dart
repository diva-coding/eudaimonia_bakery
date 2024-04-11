import 'package:flutter/material.dart';
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            size: 30,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Eudaimonia Bakery", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)
              ),
            ),
          ),
          Spacer(),
          Badge(
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(7),
            child: InkWell(
              onTap: (){},
              child: Icon(Icons.shopping_bag_outlined),
            ),
          )
        ],
      ),
    );
  }
}