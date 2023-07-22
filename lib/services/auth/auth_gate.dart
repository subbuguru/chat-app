import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/register_screen.dart';

import '../../screens/home_screen.dart';


class AuthGate extends StatelessWidget {



  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
          else {
          return const LoginScreen();
        }
      },
    );
  }
}