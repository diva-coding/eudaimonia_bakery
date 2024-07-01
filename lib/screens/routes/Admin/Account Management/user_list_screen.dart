import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/services/user_data_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = UserDataService.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
      ),
      body: FutureBuilder<List<User>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  //leading: CachedNetworkImage(imageUrl: user.imageUrl), add if you want to use cache network image
                  leading: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person), // Wrap in Icon widget
                      SizedBox(height: 4),
                    ],
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.phoneNumber),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/admin-user-detail-screen',
                      arguments:
                          user, // Pass the CustomerServiceDatas object
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("No users found."));
          }
        },
      ),
    );
  }
}
