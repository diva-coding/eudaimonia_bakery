import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/helpers/db_helper.dart';

import 'package:eudaimonia_bakery/models/menu.dart';

class EditMenuScreen extends StatefulWidget {
  Menu menu;
  EditMenuScreen({super.key, required this.menu});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  TextEditingController _titleC = TextEditingController();
  TextEditingController _descriptionC = TextEditingController();
  TextEditingController _priceC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    _titleC.text = widget.menu.title;
    _descriptionC.text = widget.menu.description;
    _priceC.text = widget.menu.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleC,
              decoration: const InputDecoration(label: Text('title')),
            ),
            TextField(
              controller: _descriptionC,
              decoration: const InputDecoration(label: Text('description')),
            ),
            TextField(
              controller: _priceC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('price'),
              ),
            ),
            GestureDetector(
              onTap: _updateMenu,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: const BoxDecoration(color: Colors.blue),
                child: const Text('Update'),
              ),
            )
          ],
        ),
      ),
    );
  }

  _updateMenu() async {
    final menu = Menu(
        id: widget.menu.id ?? 0,
        title: _titleC.text,
        description: _descriptionC.text,
        price: int.parse(_priceC.text));

    await DbHelper.updateMenu(menu: menu);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menu updated successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to the MenuScreen and refresh data
    Navigator.pop(context, true);
  }
}
