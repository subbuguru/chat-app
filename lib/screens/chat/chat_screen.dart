import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/services/profile/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/image_picker_dialog.dart';

// import chat service


class ChatScreen extends StatefulWidget {

  final String receiverEmail;
  final String receiverUid;
  final String receiverDisplayname;

  const ChatScreen({required this.receiverEmail, required this.receiverUid, required this.receiverDisplayname, super.key});

  
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  // get current user uid
  var currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  // initialize chatid
  late String chatId;

  // initialize texteditingcontroller for sendingmessage
  TextEditingController sendMessageController = TextEditingController();
  ChatService chatService = ChatService();
  ProfileService profileService = ProfileService();
  



  String generateChatId(String id1, id2) {

    List<String> ids = [id1, id2]..sort();

    return ids.join("_");
  }

  void _sendMessage() {
    if (sendMessageController.text.isNotEmpty) {
    
      chatService.sendMessage(sendMessageController.text, widget.receiverUid);
      sendMessageController.clear();
    }
  } 

  void _sendImageMessage() async {
  // Use the sendImageMessage method from chatService to send an image.
    var pickedImage = await ImagePickerDialog.pickImage(context);
    await chatService.sendImageMessage(widget.receiverUid, pickedImage!);
  }
  



  @override
  void initState() {
    super.initState();
    if (currentUserUid != null) {
      chatId = generateChatId(currentUserUid!, widget.receiverUid);
    }
    
  }


  @override
  Widget build(BuildContext context ) {
    return Scaffold(
      // appbar with email of receiver
      appBar: 
        AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profileService.getProfileImage(widget.receiverUid, 14),
            const SizedBox(height: 4), // Adjust as needed
            Text(
              widget.receiverDisplayname, style: const TextStyle(fontSize: 13) // Adjust as needed
            ),

          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          
        ],
      ),
    

      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: 
            [ 
              
              Expanded(child: _buildMessageList()),
              const SizedBox(height: 24,),
              _buildMessageField()
             
      
            ],
      
      
          ),
      )
    );
    
  }

  Widget _buildMessageField() {
    return  TextField(
                controller: sendMessageController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  prefixIcon: IconButton(onPressed: () { _sendImageMessage();}, icon: const Icon(Icons.add_a_photo)),
                  suffixIcon: IconButton(onPressed: () {
                    _sendMessage();
                  }, icon: const Icon(Icons.send))
                ),
              );
    
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    bool isCurrentUser = doc['senderId'] == FirebaseAuth.instance.currentUser!.uid;
  // set text alignment and color based on sender/ receiver
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    var color = isCurrentUser ? Colors.blue.shade900 : Colors.grey.shade800;

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isImage = data.containsKey('isImage') ? data['isImage'] : false;
    String? content = data.containsKey('content') ? data['content'] : null;
    Widget contentWidget;

    if (isImage && content != null) {
      contentWidget = 
      Container(
        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: NetworkImage(doc["content"]), fit: BoxFit.cover
              ),
   
              ),

      );

    }
    else if (content != null) {
      contentWidget = 
      Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                
              ),
              padding: const EdgeInsets.all(12),
              child: Text(doc['content'], style: const TextStyle(color: Colors.white),)
      );
    }
    else {
      contentWidget = 
      Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Text("Error: Text not loading, try again later.", style: TextStyle(color: Colors.white),)
      );

    }


    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      
          children: [
            contentWidget,
            const SizedBox(height: 4,),
            Text(DateFormat('MMM d, h:mm a').format(doc['timestamp'].toDate()), style: const TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );

  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: chatService.getMessage(currentUserUid!, widget.receiverUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        else {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var messageSnapshot = snapshot.data!.docs[index];
              return _buildMessageItem(messageSnapshot);
            }

          );
        }
      } 
    );
  }
  
}

