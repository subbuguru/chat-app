import 'package:chat_app/services/profile/profile_service.dart';
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
  final TextEditingController _bioController = TextEditingController();

  final ProfileService profileService = ProfileService();

  final _authUid = FirebaseAuth.instance.currentUser?.uid;



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
                  profileService.getProfileImage(_authUid!,75),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () async {
                        var pickedImage = await ImagePickerDialog.pickImage(context);
                        profileService.updateProfileImage(_authUid!, pickedImage);
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
                labelText: 'Display Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Handle display name and bio update.
              },
              child: const Text('Update Profile'),
            ),
            
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle password reset.
                  },
                  child: const Text('Reset Password'),
                ),
                TextButton(
              onPressed: () {
                // Handle email reset.
              },
              child: const Text('Reset Email'),
            ),
              ],
            ),
          ],
        ),
      ),
    ); 

  } 
}
