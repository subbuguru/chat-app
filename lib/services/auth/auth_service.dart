 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //init cloud firestore

  final _firestore = FirebaseFirestore.instance;


  // Method to sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      


      ///new doc for new user
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
        "displayname": displayName,
      });
 
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Method to sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password, ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Add the signOut method here as
  // You can also add other authentication methods as needed.

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,

    );

    // add user credential to user list
    _firestore.collection("users").doc(credential.token.toString()).set({
        "uid": credential.token.toString(),
        "email": googleUser.email,
        "displayname": googleUser.displayName,
      }, SetOptions(merge: true));

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);

    
  }

  

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}