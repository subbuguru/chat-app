import 'package:chat_app/screens/home/home_screen.dart';
import 'package:chat_app/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import provider
import 'package:provider/provider.dart';
import '../../services/auth/auth_navigator.dart';
import '../../services/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  //add super.key
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Asynchronously sign-up a user using email, password and displayName.
  ///
  /// Utilizes the [AuthService.signUpWithEmailAndPassword] and [AuthService.signInWithEmailAndPassword]
  /// methods for authentication.
  /// On failure, shows a Snackbar with an error message.
  Future<void> signUp(String email, String password, String displayName) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      UserCredential userCredential = await authService
          .signUpWithEmailAndPassword(email, password, displayName);

      await authService.signInWithEmailAndPassword(email, password);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
        ),
      );
    } on Exception catch (e) {
      // Show error in a Snackbar
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
    final confirmPasswordController = TextEditingController();
    final displayNameController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Create an Account",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),
                  // Email input field

                  TextFieldWidget(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    obscureText: false,
                    controller: emailController,
                  ),

                  const SizedBox(height: 16),

                  TextFieldWidget(
                    labelText: 'Display Name',
                    prefixIcon: Icons.person,
                    obscureText: false,
                    controller: displayNameController,
                  ),

                  const SizedBox(height: 16),

                  // Password input field
                  TextFieldWidget(
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                  ),

                  const SizedBox(height: 16),

                  TextFieldWidget(
                    labelText: 'Confirm Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    controller: confirmPasswordController,
                  ),

                  const SizedBox(height: 24),

                  // register button
                  ElevatedButton(
                    onPressed: () {
                      try {
                        if (passwordController.text ==
                            confirmPasswordController.text) {
                          signUp(emailController.text, passwordController.text,
                              displayNameController.text);
                        } else {
                          throw Exception(
                              'Password error: Passwords do not match, are empty, or less than 6 characters');
                        }
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: onPrimaryColor,
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 12),
                  // Text button to navigate to register page (to be implemented later)
                  GestureDetector(
                    onTap: () {
                      AuthNavigator.goToLogin(context);
                      // go to homepage
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
