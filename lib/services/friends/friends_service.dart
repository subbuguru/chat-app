import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final _firestore = FirebaseFirestore.instance;

  // Get a stream of documents from the 'friends' sub-collection of the current user
  Stream<QuerySnapshot> getFriendsAndRequests(String uid) {
    return _firestore.collection('users').doc(uid).collection('friends').snapshots();
  }

  // Send a friend request by creating a new document in the 'friends' sub-collection 
  // for both the current user and the target user. The 'isRequest' field is set to true 
  // to indicate that this document represents a friend request, not a confirmed friendship.
  Future<void> sendFriendRequest(String friendUid) async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection('users').doc(currentUid).collection('friends').doc(friendUid).set({
      'friendId': friendUid,
      
      'senderId': currentUid,
      'isRequest': true,
    });

    await _firestore.collection('users').doc(friendUid).collection('friends').doc(currentUid).set({
      'friendId': currentUid,
      "senderId": currentUid, //added this to make it easier to find the sender of the request
      'isRequest': true,
    });
  }

  // Accept a friend request by updating the 'isRequest' field of the document 
  // in the 'friends' sub-collection for both the current user and the friend to false. 
  // This indicates that the friend request has been accepted and the users are now friends.
  Future<void> acceptFriendRequest(String friendUid) async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection('users').doc(currentUid).collection('friends').doc(friendUid).update({
      'isRequest': false,
    });

    await _firestore.collection('users').doc(friendUid).collection('friends').doc(currentUid).update({
      'isRequest': false,
    });
  }

  // Decline a friend request by deleting the document in the 'friends' sub-collection 
  // for both the current user and the friend. This completely removes the record of the friend request.
  Future<void> declineFriendRequest(String friendUid) async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection('users').doc(currentUid).collection('friends').doc(friendUid).delete(); //end friendship on both ends
    await _firestore.collection('users').doc(friendUid).collection('friends').doc(currentUid).delete();
  }

 

}
