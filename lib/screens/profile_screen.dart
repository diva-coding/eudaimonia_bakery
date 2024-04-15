import 'package:eudaimonia_bakery/screens/admin/voucher_screen.dart';
import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/screens/profileaccount_screen.dart';

void main() {
  runApp(const ProfileScreen());
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 126, 89),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      
      body: SingleChildScrollView(
         child: Column( 
          children: [
            const SizedBox(height: 7),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 70.0,
                  backgroundImage: AssetImage('assets/images/me.jpg'),
                ),
                SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lovyetha Evelyn Sirait',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    'lovyethasirait@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    )
                  )
                ],
              )],
            ),
            const Divider(),
            ListTile(
              title: const Text('Account', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.account_circle,color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );// Tambahkan logika navigasi ke halaman pengaturan akun
              },
            ),
            ListTile(
              title: const Text('Ordered History', style: TextStyle(color: Colors.white),),
              leading: const Icon(Icons.assignment, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman pengaturan notifikasi
              },
            ),
            ListTile(
              title: const Text('Message', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.message, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman pengaturan pesan
              },
            ),
            ListTile(
              title: const Text('Notification', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.notifications, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman pengaturan notifikasi
              },
            ),
            ListTile(
              title: const Text('Detail Information', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.info, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman tentang aplikasi
              },
            ),
            ListTile(
              title: const Text('Discount Voucher', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.discount, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoucherScreen()),
                );// Tambahkan logika navigasi ke halaman pengaturan panggilan
              },
            ),
          ]
        ),
        )
      );
  }
}
