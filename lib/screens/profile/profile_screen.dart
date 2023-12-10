import 'package:chat_app/services/profile/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/image_picker_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();

  final ProfileService profileService = ProfileService();

  final _authUid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> _loadCurrentUserDisplayName() async {
    // Assuming that the collection is named 'users' and the document ID is the user's UID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_authUid)
        .get();
    if (userDoc.exists && userDoc.data() != null) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String displayName = userData['displayname'];
      setState(() {
        _displayNameController.text = displayName;
      });
    }
  }

  // private method to reset current users password by email
  Future<void> _resetPassword() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to ${user.email}')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user signed in')),
      );
    }
  }

  // private method to update current users display name
  Future<void> _updateCurrentUserDisplayName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_authUid)
        .update({'displayname': _displayNameController.text});

    //return a snackbar which states that the profile has been updated
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Updated'),
      ),
    );
  }

  void initState() {
    super.initState();
    _loadCurrentUserDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: <Widget>[
                  profileService.getProfileImage(_authUid!, 75),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () async {
                        var pickedImage =
                            await ImagePickerDialog.pickImage(context);
                        profileService.updateProfileImage(
                            _authUid!, pickedImage);
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Update Display Name',
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle display .
                    _updateCurrentUserDisplayName();
                    _loadCurrentUserDisplayName();
                  },
                  child: const Text('Update Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle password reset.
                    _resetPassword();
                  },
                  child: const Text('Reset Password'),
                ),
                /*TextButton(
                  onPressed: () {
                    // Handle email reset.
                  },
                  child: const Text('Reset Email'),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
