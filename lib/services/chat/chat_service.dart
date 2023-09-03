import 'dart:io';
import 'package:chat_app/services/chat/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// A service class responsible for handling all chat-related functionalities.
class ChatService {
  // Firestore instance for database operations.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Reference to the 'chats' collection in Firestore.
  final CollectionReference _chatCol = FirebaseFirestore.instance.collection('chats');

  /// Uploads an image File to Firebase Storage and returns the download URL.
  ///
  /// [file]: The File object representing the image.
  Future<String> _uploadImage(File file) async {
    try {
      // Create a reference to the Firebase Storage path where the file will be stored.
      final ref = FirebaseStorage.instance.ref().child('chat_images').child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage.
      final taskSnapshot = await ref.putFile(file);

      // Retrieve and return the download URL.
      final url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// Sends an image message to a specified receiver.
  ///
  /// [receiverId]: The receiver's user ID.
  /// [imageFile]: The File object containing the image.
  Future<void> sendImageMessage(String receiverId, File? imageFile) async {
    if (imageFile != null) {
      // Upload the image and get its URL.
      final imageUrl = await _uploadImage(imageFile);
    
      // Retrieve the current user's UID and the current time.
      final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final Timestamp timestamp = Timestamp.now();
    
      // Create a new message model object.
      MessageModel message = MessageModel(
        content: imageUrl, 
        receiverId: receiverId, 
        senderId: currentUserUid, 
        timestamp: timestamp, 
        isImage: true // Mark as an image message
      );
    
      // Compute the chatId from the sender and receiver UIDs.
      List<String> idList = [currentUserUid, receiverId];
      idList.sort();
      String chatId = idList.join("_"); 

      // Add the message to the Firestore 'chats' collection.
      await _chatCol.doc(chatId).collection("messages").add(message.toMap());
    } else {
      print('Image picking was cancelled');
    }
  }

  /// Sends a text message to a specified receiver.
  ///
  /// [content]: The content of the message.
  /// [receiverUid]: The receiver's user ID.
  Future<void> sendMessage(String content, String receiverUid) async {
    // Retrieve the current user's UID and the current time.
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message model object.
    MessageModel message = MessageModel(content: content, receiverId: receiverUid, senderId: currentUserUid, timestamp: timestamp, isImage: false );

    // Compute the chatId from the sender and receiver UIDs.
    List<String> idList = [currentUserUid, receiverUid];
    idList.sort();
    String chatId = idList.join("_"); 

    // Add the message to the Firestore 'chats' collection.
    await _chatCol.doc(chatId).collection("messages").add(message.toMap());
  }

  /// Retrieves messages between two specified users.
  ///
  /// [senderId]: The sender's user ID.
  /// [receiverId]: The receiver's user ID.
  ///
  /// Returns a Stream of QuerySnapshots containing the messages.
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(String senderId, String receiverId) {
    // Compute the chatId from the sender and receiver UIDs.
    List<String> idList = [senderId, receiverId];
    idList.sort();
    String chatId = idList.join("_"); 

    // Return a Stream of QuerySnapshots for the specified chat.
    return _firestore.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }
}
