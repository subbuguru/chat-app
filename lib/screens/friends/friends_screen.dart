// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/services/profile/profile_service.dart';

import '../../services/friends/friends_service.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _tabs = ['Friends', 'Requests'];
  final _authUid = FirebaseAuth.instance.currentUser!.uid;
  final _friendService = FriendService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          bottom: TabBar(
            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            _FriendsList(friendService: _friendService, uid: _authUid),
            _FriendsAndSearchPage(friendService: _friendService, uid: _authUid),

            
          ],
        ),
      ),
    );
  }
}

class _FriendsList extends StatelessWidget {
  final FriendService friendService;
  final String uid;

  _FriendsList({required this.friendService, required this.uid});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: friendService.getFriendsAndRequests(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading friends list: ${snapshot.error}')),
          );
          return const Center(child: Text('Error loading friends list'));
        } 
        else {
          var friends = snapshot.data!.docs.where((doc) => !doc['isRequest']);
          if (friends.isEmpty) {
            return const Center(child: Text('You have no friends yet. Add some!'));
          }
          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              // Get the friend's UID from the snapshot.
              String friendUid = friends.elementAt(index)['friendId'];

              // Fetch the friend's details from the 'users' collection using the UID.
              return FutureBuilder<DocumentSnapshot>(
                future: firestore.collection('users').doc(friendUid).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading spinner while waiting for the friend's details.
                    return const CircularProgressIndicator();
                  }
                  else if (snapshot.hasError) {
                    // Show an error message if there's an error loading the friend's details.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error loading friend info: ${snapshot.error}')),
                    );
                    return const ListTile(title: Text('Error loading info'));
                  }
                  else {
                    // Show the friend's details if the data is available.
                    var friendData = snapshot.data!.data()! as Map<String, dynamic>;
                    return ListTile(
                      leading: ProfileService().getProfileImage(friendUid, 16),
                      title: Text(friendData['displayname']),
                      subtitle: Text(friendData['email']),
                      trailing: IconButton(icon: const Icon(Icons.remove), onPressed: () {
                        friendService.declineFriendRequest(friendUid);
                      },)
                    );
                  }
                },
              );
            },

          );
        }
      },
    );
  }
}

class _FriendsAndSearchPage extends StatelessWidget {
  final FriendService friendService;
  final String uid;

  const _FriendsAndSearchPage({super.key, required this.friendService, required this.uid});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Search for Friends',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16,),
          _UserSearch(
            friendService: friendService,
          ),
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Divider(thickness: 2),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Friend Requests',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _IncomingRequests(
            friendService: friendService,
            uid: uid,
          ),
  
          
        ],
      ),
    );
  }
}



// Define `IncomingRequests` and `UserSearch` widgets in a similar way.

// This widget will display a list of incoming friend requests.
class _IncomingRequests extends StatelessWidget {
  final FriendService friendService;
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ProfileService profileService = ProfileService();

  _IncomingRequests({
    Key? key,
    required this.friendService,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: friendService.getFriendsAndRequests(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading friends list: ${snapshot.error}')),
          );
          return const Center(child: Text('Error loading friends list'));
        }

        if (snapshot.data == null) {
          return const Center(child: Text('You have no friend requests right now.'));
        }

        var friends = snapshot.data!.docs.where((doc) => doc['isRequest'] == true && doc['senderId'] != uid);

        if (friends.isEmpty) {
          return const Center(child: Text('You have no friend requests right now.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: friends.length,
          itemBuilder: (context, index) {
            String friendUid = friends.elementAt(index)['friendId'];

            return FutureBuilder<DocumentSnapshot>(
              future: firestore.collection('users').doc(friendUid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading friend info: ${snapshot.error}')),
                  );
                  return const ListTile(title: Text('Error loading info'));
                }

                if (snapshot.data?.data() == null) {
                  return const ListTile(title: Text('No requests right now.'));
                }
                
                var friendData = snapshot.data!.data() as Map<String, dynamic>;

                return ListTile(
                  leading: profileService.getProfileImage(friendUid, 16),
                  title: Text(friendData['displayname'] ?? ''),
                  subtitle: Text(friendData['email'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          friendService.acceptFriendRequest(friendUid);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          friendService.declineFriendRequest(friendUid);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}


// This widget will display a search bar to search for users and send friend requests.
class _UserSearch extends StatefulWidget {
  final FriendService friendService;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  _UserSearch({required this.friendService,});

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<_UserSearch> {
  final _searchController = TextEditingController(); // Controller for the search bar input

  Future<void> _trySendRequest(String friendEmail) async { // this function sends a friendrequest based on the uid of the email which is searched.
  try {
    // Fetch user with given email from Firestore
    var users = await widget.firestore
        .collection('users')
        .where('email', isEqualTo: friendEmail)
        .get();

    if (users.docs.isEmpty) {
      throw Exception('No user found with this email');
    }

    // Extract the uid of the fetched user
    String friendUid = users.docs.first.get('uid');

    // Check if the user is trying to send a friend request to themselves
    if (friendUid == FirebaseAuth.instance.currentUser!.uid) {
      throw Exception("You can't send a friend request to yourself");
    }

    await widget.friendService.sendFriendRequest(friendUid); // Send a friend request based on UID of friend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request sent')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Type user email to send request',
              prefixIcon: GestureDetector(child: const Icon(Icons.search,
              ), onTap:() {
                
              },), // Update search results when the value changes
              border: const OutlineInputBorder(),  // This makes the TextField box-shaped
            ),
    
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              _trySendRequest(_searchController.text); // Send a friend request when the search button is pressed
            }
          },
          child: const Text('Send friend request'),
        ),
      ],
    );
  }
}
