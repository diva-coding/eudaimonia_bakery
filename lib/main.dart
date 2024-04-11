import 'package:eudaimonia_bakery/screens/home_screen.dart';
import 'package:eudaimonia_bakery/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 179, 126, 89),
        fontFamily: 'Poppins'
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen()
      } 
    );
  }
}