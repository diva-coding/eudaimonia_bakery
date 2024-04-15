import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/helpers/db_helper.dart';
import 'package:eudaimonia_bakery/models/menu.dart';

// ...

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  TextEditingController _titleC = TextEditingController();
  TextEditingController _descriptionC = TextEditingController();
  TextEditingController _priceC = TextEditingController();
  String imageUrl = '';
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
              onTap: _insertMenu,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: const BoxDecoration(color: Color.fromARGB(255, 179, 126, 89)),
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }

  _insertMenu() async {
    final menu = Menu(
        title: _titleC.text,
        description: _descriptionC.text,
        price: int.parse(_priceC.text));

    await DbHelper.insert(menu: menu);
    Navigator.pop(context, true);
  }
}
