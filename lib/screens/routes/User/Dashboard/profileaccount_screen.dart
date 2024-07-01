import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/edit_user_screen.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _username = "";
  String _email = "";
  String _phoneNumber = "";
  String _address = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = await DatabaseHelper.instance.getUser();
    if (user != null) {
      setState(() {
        _username = user.name;
        _email = user.email;
        _phoneNumber = user.phoneNumber;
        _address = user.address;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Account', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Constants.secondaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileUser()),
              ).then((value) {
                _loadUserData();
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(_username, style: const TextStyle(fontSize: 16.0)),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(_email, style: const TextStyle(fontSize: 16.0)),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(_phoneNumber, style: const TextStyle(fontSize: 16.0)),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(_address, style: const TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
    );
  }
}
