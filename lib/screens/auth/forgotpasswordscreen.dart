import 'package:chat_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _sendPasswordResetEmail() async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
          email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent!')),
      );
      Navigator.of(context).pop(); // Pop back to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFieldWidget(
              labelText: 'Email',
              prefixIcon: Icons.email,
              obscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 26),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
