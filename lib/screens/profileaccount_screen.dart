import 'package:flutter/material.dart';

void main() {
  runApp(AccountScreen());
}

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _username = "Lovyetha Evelyn Sirait";
  String _email = "lovyethasirait@gmail.com";

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Account', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Name',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 8.0),
            Row(children: [
              Text(_username, style: TextStyle(fontSize: 16.0)),
              SizedBox(width: 140),
              IconButton(
                onPressed: () {
                  _showEditUsername();
                }, 
                icon: Icon(Icons.edit)),
            ]),
            SizedBox(height: 16.0),
            Text(
              'Email',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Row(children: [
              Text(_email, style: TextStyle(fontSize: 16.0)),
              SizedBox(width: 100),
              IconButton(
                onPressed: () {
                  _showEditEmail();
                }, 
                icon: Icon(Icons.edit)),
            ])
          ],
        ),
      ),
    );
  }

  void _showEditUsername() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Name'),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = _usernameController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }
  
  void _showEditEmail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Email'),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = _emailController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}
