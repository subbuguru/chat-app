import 'package:chat_app/auth_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  


  Future<void> signIn(String email, String password) async {
    // Add the signInWithEmailAndPassword method here
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(email, password);


    }on Exception catch (e){

      // show errror in a snackbar
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
                  const Text("Let's Chat.", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              
                  const SizedBox(height: 24),
                  // Message icon (you can replace this with your own icon)
                  Icon(
                    Icons.message,
                    size: 140,
                    color: primaryColor,
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
                  // Text button to navigate to register page (to be implemented later)
                  GestureDetector(
                    onTap:() => AuthNavigator.goToRegister(context),
                    child: Text(
                      'Create an account',
                      style: TextStyle(color: primaryColor),
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
