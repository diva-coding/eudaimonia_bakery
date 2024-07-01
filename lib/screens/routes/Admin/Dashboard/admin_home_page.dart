import 'package:eudaimonia_bakery/cubit/auth/auth_cubit.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Account Management/user_list_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Order Management/order_list_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Product Management/Product Category Management/category_list_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Product Management/product_list_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Menu/list_type_product.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AdminHomePage extends StatefulWidget {
  final int initialIndex;

  const AdminHomePage({super.key, this.initialIndex = 0});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex; // Set initial index from the parameter
  }

  final List<Widget> _screens = [
    const ProductListScreen(),
    const ProductCategoryListScreen(),
    const UserListScreen(),
    const OrderListScreen(),
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
                accountName: Text('Lovyetha Evelyn Sirait'),
                accountEmail: Text('lovyethasirait@gmail.com')),
            ListTile(
              title: const Text('Product'),
              selected: ProductListScreen == 0,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index = 0);
              },
            ),
            ListTile(
              title: const Text('Category'),
              selected: CategoryListScreen == 1,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index = 1);
              },
            ),
            ListTile(
              title: const Text('User'),
              selected: UserListScreen == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index = 2);
              },
            ),
            ListTile(
              title: const Text('Order'),
              selected: OrderListScreen == 3,
              onTap: () {
                Navigator.pop(context);
                setState(() => _index = 3);
              },
            ),
            ListTile(
                title:
                    const Text('Logout', style: TextStyle(color: Colors.black)),
                leading: const Icon(Icons.logout, color: Colors.black),
                onTap: () async {
                  // 1. Delete data from SQLite
                  await DatabaseHelper.instance.deleteUser();

                  // 2. Delete token from secure storage
                  await SecureStorageUtil.storage.delete(key: tokenStoreName);
                  await SecureStorageUtil.storage.delete(key: role);

                  // 3. Trigger logout in your Cubit
                  context.read<AuthCubit>().logout();

                  // 4. Navigate to login screen (replace the current route)
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login-screen', (route) => false);
                }),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Eudaimonia Bakery',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Constants.secondaryColor,
      ),
      body: _screens[_index],
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: <SalomonBottomBarItem>[
            SalomonBottomBarItem(
                icon: const Icon(Icons.business),
                title: const Text('Products')),
            SalomonBottomBarItem(
                icon: const Icon(Icons.category),
                title: const Text('Category')),
            SalomonBottomBarItem(
                icon: const Icon(Icons.person), title: const Text('User')),
            SalomonBottomBarItem(
                icon: const Icon(Icons.assignment), title: const Text('Order')),
          ]),
    );
  }
}
