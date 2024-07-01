import 'dart:convert';

import 'package:eudaimonia_bakery/cubit/auth/auth_cubit.dart';
import 'package:eudaimonia_bakery/dto/login.dart';
import 'package:eudaimonia_bakery/screens/routes/Auth/LoginScreen/forgot_password.dart';
import 'package:eudaimonia_bakery/screens/routes/Auth/RegisterScreen/register.dart';
import 'package:eudaimonia_bakery/services/data_services.dart';
import 'package:eudaimonia_bakery/services/user_database_helper.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthCubit? authCubit;
  late Color myColor;
  late Size mediaSize;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberUser = false;
  bool _isPasswordVisible = false; // State variable for password visibility

  @override
  void initState()  {
    super.initState();
    _checkLoginUser();
  }

  Future<void> _checkLoginUser() async {
    final accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);
    final roles = await SecureStorageUtil.storage.read(key: role);
    if (accessToken != null) {
      authCubit?.login(accessToken);
      final userRoles = roles;
      if (userRoles == 'user') {
        Navigator.pushReplacementNamed(context, "/home-page");
      } else if (userRoles == 'admin') {
        Navigator.pushReplacementNamed(context, "/admin-home-page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Constants.secondaryColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/logo.png", width: 100, height: 100),
          const Text(
            "Eudaimonia Bakery",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 1),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome!",
          style: TextStyle(
              color: Constants.secondaryColor,
              fontSize: 32,
              fontWeight: FontWeight.bold),
        ),
        _buildGreyText("Please login with your information"),
        const SizedBox(height: 30),
        _buildGreyText("Email address"),
        _buildInputField(_emailController),
        const SizedBox(height: 20),
        _buildGreyText("Password"),
        _buildInputField(_passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildSignUp(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Constants.secondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : const Icon(Icons.email, color: Constants.secondaryColor),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Constants.secondaryColor)),
      ),
      obscureText: isPassword && !_isPasswordVisible,
      cursorColor: Constants.secondaryColor,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Checkbox(
                  value: state.rememberMe,
                  onChanged: (value) {
                    context.read<AuthCubit>().toggleRememberMe(value!);
                  },
                  checkColor: Constants.primaryColor,
                  activeColor: Constants.secondaryColor,
                );
              },
            ),
            _buildGreyText("Remember me"),
          ],
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgotPassScreen()),
              );
            },
            child: _buildGreyText("I forgot my password"))
      ],
    );
  }

  Widget _buildLoginButton() {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return ElevatedButton(
      onPressed: () => sendLogin(context, authCubit),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: Constants.secondaryColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("LOGIN",
          style: TextStyle(fontSize: 18, color: Constants.secondaryColor)),
    );
  }

  Widget _buildSignUp() {
    return Center(
        child: Row(
      children: [
        const SizedBox(width: 30),
        _buildGreyText("Don't have any account?"),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAccount()),
              );
            },
            child: _buildGreyText("Sign Up"))
      ],
    ));
  }

  void sendLogin(BuildContext context, AuthCubit authCubit) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await DataService.sendLoginData(email, password);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final loggedIn = Login.fromJson(data);

      try {
        // Perform async operations concurrently
        if (authCubit.state.rememberMe == true) {
          await Future.wait([
            SecureStorageUtil.storage
                .write(key: tokenStoreName, value: loggedIn.accessToken),
            SecureStorageUtil.storage
                .write(key: role, value: loggedIn.userData.role),
            DatabaseHelper.instance.insertOrUpdateUser(loggedIn.userData),
          ]);
        } else {
          await Future.wait([
          SecureStorageUtil.storage
            .write(key: role, value: loggedIn.userData.role),
          DatabaseHelper.instance.insertOrUpdateUser(loggedIn.userData),
        ]);
        }

        authCubit.login(loggedIn.accessToken);

        if (loggedIn.userData.role == 'user') {
          Navigator.pushReplacementNamed(context, "/home-page");
        } else if (loggedIn.userData.role == 'admin') {
          Navigator.pushReplacementNamed(context, "/admin-home-page");
        }

        debugPrint(loggedIn.accessToken);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Login Successful"),
              duration: Duration(seconds: 2)),
        );
      } on PlatformException catch (e) {
        // Handle platform-specific errors (e.g., permissions)
        debugPrint("PlatformException: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("A platform error occurred"),
              duration: Duration(seconds: 2)),
        );
      } on DatabaseException catch (e) {
        // Handle SQLite database errors
        debugPrint("SqliteException: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("A database error occurred"),
              duration: Duration(seconds: 2)),
        );
      } catch (e) {
        // Catch-all for other unexpected errors
        debugPrint("Unknown error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("An unknown error occurred"),
              duration: Duration(seconds: 2)),
        );
      }
    } else {
      debugPrint("failed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Login Failed"), duration: Duration(seconds: 2)),
      );
    }
  }
}
