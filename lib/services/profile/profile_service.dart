import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/image_picker_dialog.dart';

class ProfileService {
  final _firestore = FirebaseFirestore.instance;
  final _imagePickerDialog = ImagePickerDialog();

  StreamBuilder<DocumentSnapshot> getProfileImage(String uid, double? avatarRadius) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const  CircleAvatar(
            child: Icon(Icons.error),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return CircleAvatar(
       
            radius: avatarRadius,
            backgroundColor: Colors.grey,
            child: Text(
              "U",
              style: TextStyle(
                color: Colors.white,
                fontSize: avatarRadius,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        if (data != null) {
          if (data['profileImageUrl'] != null) {
            return CircleAvatar( // if profile image exists we return it
              radius: avatarRadius,
              backgroundImage: NetworkImage(data['profileImageUrl']),
            );
          } else {
            return CircleAvatar( // if no profile image we return the user's initial
              radius: avatarRadius,
              backgroundColor: Colors.grey,
              child: Text(
                data['displayname'][0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: avatarRadius,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        } else {
          return CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.grey,
            child: Text(
              "U",
              style: TextStyle(
                color: Colors.white,
                fontSize: avatarRadius,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }

  
  


  /// Function to upload a File to Firebase Storage and return the download URL
  Future<String> _uploadProfileImage(File file) async {
    try {
      // Create a reference to the location in Firebase Storage where the file will be stored
      final ref = FirebaseStorage.instance.ref().child('chat_images').child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

      // Upload the file
      final taskSnapshot = await ref.putFile(file);

      // Get the download URL and return it
      final url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      // If there was an error, print it and rethrow it
      print(e);
      rethrow;
    }
  }

  // updateProfileImage using above 2 methods
  Future<void> updateProfileImage(String uid, File? imageFile) async {
    try {
      // Pick an image

      if (imageFile == null) return;

      // Upload the image to Firebase Storage and get the download URL
      final downloadUrl = await _uploadProfileImage(imageFile);

      // Save the download URL to Firestore
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': downloadUrl,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
