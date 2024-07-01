import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/screens/routes/USer/Menu/search_product_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/home_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/menu_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/profile_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Menu/list_type_product.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Transaction/cart_screen.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await DatabaseHelper.instance.getUser();
    setState(() {
      _user = user;
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryListScreen(),
    const ProductSearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Constants.secondaryColor,
              ),
              accountName: Text(_user!.name),
              accountEmail: Text(_user!.email),
              currentAccountPicture: const CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/images/background.png'),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              selected: HomeScreen == 0,
              onTap: () {
                setState(()  => _index = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Menu'),
              selected: MenuScreen == 1,
              onTap: () {
                Navigator.pop(context);
                setState(()  => _index =1);
              },
            ),
            ListTile(
              title: const Text('Search'),
              selected: ProductSearchScreen == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index =2);
              },
            ),
            ListTile(
              title: const Text('Cart'),
              selected: CartScreen == 3,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index =3);
              },
            ),
              ListTile(
              title: const Text('Profile'),
              selected: ProfileScreen == 4,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index =4);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Eudaimonia Bakery', style: 
        TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center
        ),
        centerTitle: true,
      ),
      body: _screens[_index],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: <SalomonBottomBarItem>[
          SalomonBottomBarItem(
            icon: const Icon(Icons.home), title: const Text('Home')),
          SalomonBottomBarItem(
            icon: const Icon(Icons.dining), title: const Text('Menu')),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search), title: const Text('Search')),
          SalomonBottomBarItem(
            icon: const Icon(Icons.shopping_cart), title: const Text('Cart')),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person), title: const Text('Profile')),
      ]),
    );
  }
}

