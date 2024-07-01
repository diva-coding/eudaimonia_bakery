import 'package:eudaimonia_bakery/screens/routes/Admin/Dashboard/admin_home_page.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontSize: 20)),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Manage Products screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>   const AdminHomePage(initialIndex: 1)),
               );
              },
              child: const Text('Manage Products'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Manage Orders screen
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>   const AdminHomePage(initialIndex: 4)),
               );
              },
              child: const Text('Manage Orders'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to View Reports screen
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>   const AdminHomePage(initialIndex: 3)),
               );
              },
              child: const Text('View Users'),
            ),
            // Add more buttons as needed
          ],
        ),
      ),
    );
  }
}
