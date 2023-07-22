import 'package:chat_app/auth_navigator.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
// import provider
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {

  //add super.key
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


 
  Future<void> signUp(String email, String password) async {
    // Add the signInWithEmailAndPassword method here
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailAndPassword(email, password);
      
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
    final confirmPasswordController = TextEditingController();

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
                  const Text("Sign Up.", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              
                  const SizedBox(height: 24),
                  // Message icon (you can replace this with your own icon)
                  Icon(
                    Icons.message,
                    size: 140,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 24),
                  // Email input field
                  
                  TextFieldWidget (
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    obscureText: false,
                    controller: emailController,
                  ),
              
                  const SizedBox(height: 16),
              
                  // Password input field
                  TextFieldWidget (
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                  ),
              
                  const SizedBox(height: 16),
                  
                  TextFieldWidget (
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
                        if (passwordController.text == confirmPasswordController.text) {
                          signUp(emailController.text, passwordController.text);
                        } else {
                          throw Exception('Passwords do not match');
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
                      style: TextStyle(color: primaryColor,  ),
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
