import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/screens/home_screen.dart';
import 'package:eudaimonia_bakery/screens/menu_screen.dart';
import 'package:eudaimonia_bakery/screens/profile_screen.dart';
import 'package:eudaimonia_bakery/screens/shopping_cart_screen.dart';
import 'package:eudaimonia_bakery/screens/admin/voucher_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:eudaimonia_bakery/screens/routes/Menu/list_type_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  List<Widget> _screens = [
    HomeScreen(),
    ProductListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Constants.secondaryColor,
              ),
              accountName: Text ('Lovyetha Evelyn Sirait'), 
              accountEmail: Text ('lovyethasirait@gmail.com')
            ),
            ListTile(
              title: const Text('CRUD API | Manage Voucher'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherScreen()));
              },
            ),
            Divider(),
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
              title: const Text('Profile'),
              selected: ProfileScreen == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index =2);
              },
            ),

          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Eudaimonia Bakery', style: 
        TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center
        ),
        centerTitle: true,
        actions: [
          Badge(
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(7),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
              },
              child: Icon(Icons.shopping_bag_outlined),
            ),
          )
        ],
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
            icon: const Icon(Icons.person), title: const Text('Profile')),
      ]),
    );
  }
}

