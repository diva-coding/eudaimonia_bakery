import 'dart:async';

import 'package:eudaimonia_bakery/screens/routes/Auth/LoginScreen/password_reset_screen.dart';
import 'package:eudaimonia_bakery/services/data_services.dart';
import 'package:flutter/material.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final DataService authService = DataService();
  bool isLoading = false;
  bool isEmailLocked = false;
  bool canResendToken = true;
  Timer? resendTimer;

  void handlePasswordRecovery() async {
    final email = emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password recovery email sent')),
      );

      setState(() {
        isEmailLocked = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password recovery email: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
        canResendToken = false;
        resendTimer = Timer(const Duration(seconds: 15), () {
          setState(() {
            canResendToken = true;
          });
        });
      });
    }
  }

  void handleTokenValidation() async {
    final token = tokenController.text;
    final email = emailController.text;

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the token')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final isValidToken = await authService.validateResetToken(email, token);

      if (isValidToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email, token: token),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleEmailEdit() {
    setState(() {
      isEmailLocked = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    tokenController.dispose();
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.lock_outline,
                size: 100.0,
                color: Colors.grey,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Forgot your Password?',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Don't worry! You can reset your password by following the instructions sent to your registered email address in this app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Stack(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      suffixIcon: isEmailLocked
                          ? IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: handleEmailEdit,
                            )
                          : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    readOnly: isEmailLocked,
                  ),
                  if (isLoading && !isEmailLocked)
                    const Positioned(
                      right: 10,
                      top: 10,
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              const SizedBox(height: 20.0),
              if (isEmailLocked)
                Column(
                  children: [
                    TextField(
                      controller: tokenController,
                      decoration: const InputDecoration(
                        labelText: 'Token',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20.0),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: handleTokenValidation,
                            child: const Text('Submit Token'),
                          ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: canResendToken ? handlePasswordRecovery : null,
                      child: Text(
                        canResendToken ? 'Resend Token' : 'Wait 15 seconds to resend',
                      ),
                    ),
                  ],
                ),
              if (!isEmailLocked)
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: handlePasswordRecovery,
                        child: const Text('Recover Password'),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}