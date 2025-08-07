import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // final String senderName;
  //final String senderImage;
  final String message;
  final DateTime date;
  final String email;
  final String? documentId;
  final String? audio;
  final String? type; 
  final String senderId;
  final String receiverId;          
        
  final int? duration; 
  //final bool isMe;
  
  

  Message( {
    // required this.senderName,
    //required this.senderImage,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.date,
    required this.email,
    this.documentId,
    this.audio,
    this.type, this.duration,
    
  });
  factory Message.fromJson(jsonData) {
    return Message(
      message: jsonData['message'],
      date: (jsonData['date'] as Timestamp).toDate(),
      email: jsonData['email'],
      documentId: jsonData.id,
      audio: jsonData['audio'],
      type: jsonData['type'],           
         
      duration: jsonData['duration'],
       senderId: jsonData['senderId'],
        receiverId: jsonData['receiverId'],   
    );
  }
}
