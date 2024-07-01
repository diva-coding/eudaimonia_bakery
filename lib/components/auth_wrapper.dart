import 'package:eudaimonia_bakery/cubit/auth/auth_cubit.dart';
import 'package:eudaimonia_bakery/screens/routes/auth/LoginScreen/login_screen.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;
  final String allowedRole; // Specify the required role for this wrapper

  const AuthWrapper({super.key, required this.child, required this.allowedRole});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserDataFromSecureStorage();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return FutureBuilder<Map<String, dynamic>?>(
      future: _userDataFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final userData = snapshot.data;
          if (authCubit.state.rememberMe == true) {
            if (userData != null && userData['accessToken'] == authCubit.state.accessToken) {
              final userRole = userData['roles']; // Get the user's role
              if (userRole == widget.allowedRole) {
                return widget.child; // Display the child screen if role matches
              } else {
                // Redirect to a screen indicating insufficient permissions (e.g., an error screen)
                return const LoginScreen();
              }
            } else {
              return const LoginScreen(); // Redirect to login if no data or mismatch
            }
          } else {
            if (userData != null && authCubit.state.accessToken != null) {
              final userRole = userData['roles']; // Get the user's role
              if (userRole == widget.allowedRole) {
                return widget.child; // Display the child screen if role matches
              } else {
                // Redirect to a screen indicating insufficient permissions (e.g., an error screen)
                return const LoginScreen();
              }
            } else {
              return const LoginScreen(); // Redirect to login if no data or mismatch
            }
          }
        } else {
          return const Center(child: CircularProgressIndicator()); // Loading indicator
        }
      },
    );
  }

  Future<Map<String, dynamic>?> _getUserDataFromSecureStorage() async {
    try {
      final accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);
      final roles = await SecureStorageUtil.storage.read(key: role); // Assuming you've stored the role
      return {'accessToken': accessToken, 'roles': roles}; 
    } catch (e) {
      debugPrint('Error retrieving user data: $e');
      return null;
    }
  }
}
