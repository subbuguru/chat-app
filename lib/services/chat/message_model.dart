import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String senderId;
  String receiverId;
  String content;
  Timestamp timestamp;
  bool isImage;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isImage,
  });

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
      'isImage': isImage,
    };
  }

  // From Map
  MessageModel.fromMap(Map<String, dynamic> map)
      : senderId = map['senderId'],
        receiverId = map['receiverId'],
        content = map['content'],
        timestamp = map['timestamp'],
        isImage = map['isImage'];
}
