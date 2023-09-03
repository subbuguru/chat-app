import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';


class AuthNavigator {
  static void goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );

    
  }

  static void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );

    
  }

}


