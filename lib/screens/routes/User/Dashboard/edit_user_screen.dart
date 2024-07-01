import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:flutter/material.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({super.key});

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
        _usernameController.text = user.name;
        _emailController.text = user.email;
        _phoneNumberController.text = user.phoneNumber;
        _addressController.text = user.address;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    User? oldUser = await DatabaseHelper.instance.getUser();
    User user = User(
      userId: 1,
      name: _usernameController.text,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
      address: _addressController.text,
      createdAt: oldUser!.createdAt,
      updatedAt: DateTime.now(),

    );
    try {
      await DatabaseHelper.instance.syncUserData(user);
      Navigator.pop(context, true);
    } catch (e) {
      print('Error syncing user data: $e');
      // Handle error (show message, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _saveUserData,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
