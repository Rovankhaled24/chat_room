import 'package:chat_room/const.dart';
import 'package:chat_room/models/message.dart';
import 'package:chat_room/views/change_back_ground.dart';
import 'package:chat_room/views/change_chat_box.dart';
import 'package:chat_room/widgets/chat_box.dart';
import 'package:chat_room/widgets/chat_for_me.dart';
import 'package:chat_room/widgets/message_bar.dart';
import 'package:chat_room/widgets/status_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessages,
  );

  String selectedBackground = 'assets/bg.jpg';
  Color selectedChatBoxColor = const Color(0xFF6C52FF);

  final scrollController = ScrollController();

  String? currentUserId;
  String? receiverId;
  String? receiverName;
  String? currentEmail;

  void changeBackground(String newBackground) {
    setState(() {
      selectedBackground = newBackground;
      print('Changing background to: $newBackground');
    });
  }

  void changeChatBoxColor(Color newChatBoxColor) {
    setState(() {
      selectedChatBoxColor = newChatBoxColor;
      print('Changing chat box color to: $newChatBoxColor');
    });
  }

  Future<void> getUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      currentUserId = currentUser?.uid;
      currentEmail = currentUser?.email;

      final usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (var doc in usersSnapshot.docs) {
        if (doc.id != currentUserId) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          setState(() {
            receiverId = doc.id;

            if (data.containsKey('name')) {
              receiverName = data['name'];
            } else if (data.containsKey('email')) {
              receiverName = data['email'];
            } else {
              receiverName = 'User';
            }
          });
          break;
        }
      }
    } catch (e) {
      print('Error getting users: $e');

      setState(() {
        receiverName = 'Assistant';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          (receiverId == null)
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<QuerySnapshot>(
                stream: messages.orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Message> messagesList = [];
                    for (var doc in snapshot.data!.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      messagesList.add(
                        Message(
                          message:
                              data.containsKey('message')
                                  ? data['message']
                                  : '',
                          date: (data['date'] as Timestamp).toDate(),
                          email: data['email'] ?? '',
                          documentId: doc.id,
                          audio:
                              data.containsKey('audio') ? data['audio'] : null,
                          type:
                              data.containsKey('type') ? data['type'] : 'text',
                          duration:
                              data.containsKey('duration')
                                  ? data['duration']
                                  : null,
                          senderId:
                              data.containsKey('senderId')
                                  ? data['senderId']
                                  : '',
                          receiverId:
                              data.containsKey('receiverId')
                                  ? data['receiverId']
                                  : '',
                        ),
                      );
                    }

                    return SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(selectedBackground),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            StatusBar(
                              onChangeBackground: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChangeBackGroundScreen(
                                          onBackgroundSelected:
                                              changeBackground,
                                        ),
                                  ),
                                );
                              },
                              onBackgroundSelected: changeBackground,
                              onChangeChatBox: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChangeChatBoxScreen(
                                          onColorSelected: changeChatBoxColor,
                                        ),
                                  ),
                                );
                              },
                              onChatBoxColorSelected: changeChatBoxColor,
                              receiverName: receiverName ?? 'Assistant',
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                controller: scrollController,
                                itemCount: messagesList.length,
                                itemBuilder: (context, index) {
                                  final msg = messagesList[index];
                                  return msg.email == currentEmail
                                      ? ChatForMe(
                                        message: msg,
                                        chatBoxColor: selectedChatBoxColor,
                                      )
                                      : ChatBox(
                                        message: msg,
                                        receivername:
                                            receiverName ?? 'assistant',
                                      );
                                },
                              ),
                            ),
                            Message_bar(
                              scrollController: scrollController,
                              email: currentEmail!,
                              senderId: currentUserId!,
                              receiverId: receiverId!,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
    );
  }
}
