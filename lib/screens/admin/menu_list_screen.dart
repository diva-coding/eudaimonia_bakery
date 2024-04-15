import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eudaimonia_bakery/screens/admin/add_menu_screen.dart';
import 'package:eudaimonia_bakery/screens/admin/edit_menu_screen.dart';
import 'package:eudaimonia_bakery/helpers/db_helper.dart';
import 'package:eudaimonia_bakery/models/menu.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // DbHelper.deleteAllMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: DbHelper.getMenus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Menu is Empty'),
              );
            }
            List<Menu> menus = snapshot.data ?? [];
            return ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                String formatIdrPrice =
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                        .format(menus[index].price);
                return Card(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 200,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menus[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(formatIdrPrice)
                              ],
                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditMenuScreen(
                                              menu: menus[index])),
                                    ).then((result) {
                                      if (result != null && result as bool) {
                                        // Refresh data if result is true
                                        setState(() {});
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () => _showDeleteConfirmationDialog(
                                      menus[index]),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMenuScreen()),
            ).then((result) {
              if (result != null && result as bool) {
                // Refresh data if result is true
                setState(() {});
              }
            });
          },
          child: const Text('Add Menu', textAlign: TextAlign.center,),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Menu menu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this menu?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Call the delete function
                _deleteMenu(menu: menu);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  _deleteMenu({required Menu menu}) async {
    await DbHelper.delete(menu: menu);
    setState(() {});
  }
}
