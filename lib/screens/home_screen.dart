import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  //super.key
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the app bar
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // sign out button
          IconButton(
            onPressed: () {_authService.signOut();},
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // Add the body
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}