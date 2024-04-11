import 'package:flutter/material.dart';
import 'package:eudaimonia_bakery/screens/profileaccount_screen.dart';

void main() {
  runApp(ProfileScreen());
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
      backgroundColor: Color.fromARGB(255, 179, 126, 89),
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      
      body: SingleChildScrollView(
         child: Column( 
          children: [
            SizedBox(height: 7),
            Row(
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
            Divider(),
            ListTile(
              title: Text('Account', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.account_circle,color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );// Tambahkan logika navigasi ke halaman pengaturan akun
              },
            ),
            ListTile(
              title: Text('Ordered History', style: TextStyle(color: Colors.white),),
              leading: Icon(Icons.assignment, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman pengaturan notifikasi
              },
            ),
            ListTile(
              title: Text('Discount', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.discount, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman pengaturan panggilan
              },
            ),
            ListTile(
              title: Text('Message', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.message, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman pengaturan pesan
              },
            ),
            ListTile(
              title: Text('Notification', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.notifications, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman pengaturan notifikasi
              },
            ),
            ListTile(
              title: Text('Detail Information', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.info, color: Colors.white),
              onTap: () {
                // Tambahkan logika navigasi ke halaman tentang aplikasi
              },
            ),
          ],
        ),
        )
      );
  }
}
