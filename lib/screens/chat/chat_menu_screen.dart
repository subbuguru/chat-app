import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_service.dart';
import '../../services/profile/profile_service.dart';

class ChatMenuScreen extends StatefulWidget {
  const ChatMenuScreen({super.key});

  @override
  State<ChatMenuScreen> createState() => _ChatMenuScreenState();
}

class _ChatMenuScreenState extends State<ChatMenuScreen> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  ProfileService profileService = ProfileService();
  ChatService chatService = ChatService();
  FirebaseAuth auth = FirebaseAuth.instance;

  int totalUsers = 0;

  void signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Widget _getLastMessage(bool isContent, String receiverUid) {
    // Construct the chat ID based on the user's UID and the receiver's UID. If it is  a timestamp put false for isContent. We also need the receiver uid which is passed in.
    String chatId = "${auth.currentUser!.uid}_$receiverUid";

    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessage(auth.currentUser!.uid, receiverUid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          if (isContent) {
            return const Text("No messages yet.");
          } else {
            return const Text("");
          }
        }

        var data = snapshot.data!.docs[0].data() as Map<String, dynamic>;
        if (isContent) {
          // check if the message is an image
          if (data['isImage']) {
            return const Text("Image");
          }
          return Text(data['content'] ?? "No messages");
        } else {
          return Text(DateFormat('MMM d, h:mm a')
              .format(data['timestamp'].toDate())); // to fix
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("chat"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to handle adding a new group chat
        },
        child: Icon(Icons.group_add), // Using a group_add icon as an example
        tooltip: 'Add Group Chat', // Describes the action on long press
        // Ensures visibility
      ), */
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('friends')
            .where('isRequest', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return FutureBuilder<DocumentSnapshot>(
                future: usersRef.doc(document.id).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return ListTile(
                        title: Text(
                            'Error loading friend info: ${snapshot.error}'));
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data()! as Map<String, dynamic>;

                    return ListTile(
                      leading: profileService.getProfileImage(
                        document.id,
                        26,
                      ),
                      title: Text(
                        data['displayname'] ?? "no display name",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: _getLastMessage(
                          true, data['uid'] ?? "No messages yet."),
                      trailing: _getLastMessage(false, data['uid'] ?? ""),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      receiverEmail: data['email'],
                                      receiverUid: data["uid"],
                                      receiverDisplayname: data["displayname"],
                                    )));
                      },
                    );
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
