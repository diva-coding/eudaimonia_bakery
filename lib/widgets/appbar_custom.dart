import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/screens/shopping_cart_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;

  CustomAppBar({required this.title, this.automaticallyImplyLeading = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      backgroundColor: Constants.secondaryColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        Badge(
          backgroundColor: Colors.red,
          padding: EdgeInsets.all(7),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
              );
            },
            child: Icon(Icons.shopping_bag_outlined),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
