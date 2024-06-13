import 'package:eudaimonia_bakery/screens/home_page.dart';
import 'package:eudaimonia_bakery/screens/home_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/LoginScreen/login_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/RegisterScreen/register.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 179, 126, 89),
        fontFamily: 'Poppins'
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      initialRoute: '/login-screen',
      routes: {
        '/create-account': (context) => const CreateAccount(),
        '/login-screen': (context) => const LoginScreen(),
        '/home-page': (context) => const HomePage(),
        '/home-screen' :(context) => const HomeScreen(),
      },
    );
  }
}