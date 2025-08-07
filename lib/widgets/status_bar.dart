import 'package:chat_room/const.dart';
import 'package:chat_room/views/change_back_ground.dart';
import 'package:chat_room/views/change_chat_box.dart';
import 'package:chat_room/views/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatusBar extends StatelessWidget {
  StatusBar({super.key, required this.onChangeBackground, required this.onBackgroundSelected, required this.onChangeChatBox, required this.onChatBoxColorSelected, required this.receiverName});
  final VoidCallback onChangeBackground;
  final VoidCallback onChangeChatBox;
  final Function(String) onBackgroundSelected;
  final Function(Color) onChatBoxColorSelected;
    final String receiverName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: primaryGradientColor),
      height: 92,
      width: double.infinity,

      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/girl.png'),
            ),
            SizedBox(width: 10),
            Text
              ( receiverName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Spacer(flex: 1),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.local_phone_outlined,
                size: 28,
                color: Colors.white,
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                FontAwesomeIcons.ellipsis,
                size: 28,
                color: Colors.white,
              ),
              
              position: PopupMenuPosition.under,
              offset: Offset(0, 10), 
              onSelected: (String choice) async {
                if (choice == 'background') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeBackGroundScreen(
                        
                        onBackgroundSelected: onBackgroundSelected,
                      ),
                    ),
                  );
                } else if (choice == 'chatbox') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeChatBoxScreen(onColorSelected: onChatBoxColorSelected),
                    ),
                  );
                } else if (choice == 'logout') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                } else if(choice=='delete'){
                  final collection = FirebaseFirestore.instance.collection('messages');

    final snapshots = await collection.get(); 

    for (final doc in snapshots.docs) {
      await doc.reference.delete(); 
    }
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'background',
                      child: Text('Change Background'),
                    ),
                    PopupMenuItem<String>(
                      value: 'chatbox',
                      child: Text('Change Chat Box'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('delete the  conversation'),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Log Out'),
                    ),
                   
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
