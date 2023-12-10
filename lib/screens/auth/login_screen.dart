import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_navigator.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/text_field_widget.dart';
import '../home/home_screen.dart';

/// A screen that provides an interface for user login.
///
/// It uses [AuthService] for authentication and navigates to [HomeScreen]
/// after a successful login. Also handles Google sign-in and navigating to the
/// register screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Asynchronously sign-in a user using email and password.
  ///
  /// Utilizes the [AuthService.signInWithEmailAndPassword] method for authentication.
  /// On success, navigates the user to [HomeScreen].
  /// On failure, shows a Snackbar with an error message.
  Future<void> signIn(String email, String password) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      UserCredential userCredential =
          await authService.signInWithEmailAndPassword(email, password);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } on Exception catch (e) {
      // Show error message in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithGoogle();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } on Exception catch (e) {
      // Show error message in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title text
                  const Text("Let's Chat",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),

                  const SizedBox(height: 16),

                  // Message icon (replaceable)
                  Icon(
                    Icons.message,
                    size: 120,
                    color: primaryColor,
                  ),

                  const SizedBox(height: 8),

                  // Email input field
                  TextFieldWidget(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    obscureText: false,
                    controller: emailController,
                  ),

                  const SizedBox(height: 16),

                  // Password input field
                  TextFieldWidget(
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                  ),

                  const SizedBox(height: 24),

                  // Login button
                  ElevatedButton(
                    onPressed: () {
                      signIn(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: onPrimaryColor,
                    ),
                    child: const Text('Log in'),
                  ),

                  const SizedBox(height: 16),

                  /*  // Google Sign-in button
                  ElevatedButton(
                    onPressed: () {
                      final authService = Provider.of<AuthService>(context, listen: false);
                      signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: onPrimaryColor,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sign in with Google'),
                      ],
                    ),
                  ), */

                  const SizedBox(height: 16),

                  // row for create an account, forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () => AuthNavigator.goToRegister(context),
                          child: Text(
                            'Create an Account',
                            style: TextStyle(color: primaryColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      //navigate to forgot password screen
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            AuthNavigator.goToForgotPassword(context);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: primaryColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                  // Navigate to register screen
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
