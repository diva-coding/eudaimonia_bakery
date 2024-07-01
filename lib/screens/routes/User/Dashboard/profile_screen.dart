import 'package:eudaimonia_bakery/cubit/auth/auth_cubit.dart';
import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/about_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/profileaccount_screen.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ProfileScreen());
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch user data when the screen initializes
  }

  Future<void> _loadUserData() async {
    final user = await DatabaseHelper.instance.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 179, 126, 89),
        appBar: AppBar(
          title: const Text('Profile',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 179, 126, 89),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                const CircleAvatar(
                  radius: 70.0,
                  backgroundImage: AssetImage('assets/images/background.png'),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?.name ?? "Loading...",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _user?.email ?? "Loading...",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Divider(),
            ListTile(
              title:
                  const Text('Account', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.account_circle, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountScreen()),
                ); // Tambahkan logika navigasi ke halaman pengaturan akun
              },
            ),
            ListTile(
              title: const Text(
                'Ordered History',
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(Icons.assignment, color: Colors.white),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/order-history',
                );
              },
            ),
            ListTile(
              title: const Text('About', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.info, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            ListTile(
              title:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.logout, color: Colors.white),
              onTap: () async {
                // 1. Delete data from SQLite
                await DatabaseHelper.instance.deleteUser(); 

                // 2. Delete token from secure storage
                await SecureStorageUtil.storage.delete(key: tokenStoreName);
                await SecureStorageUtil.storage.delete(key: role);

                // 3. Trigger logout in your Cubit
                context.read<AuthCubit>().logout();

                // 4. Navigate to login screen (replace the current route)
                Navigator.pushNamedAndRemoveUntil(context, '/login-screen', (route) => false);
              }
            ),
          ]),
        ));
  }
}
