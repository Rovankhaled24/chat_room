import 'package:chat_room/const.dart';
import 'package:chat_room/models/chat_box_card_model.dart';
import 'package:chat_room/widgets/chat_box_card.dart';
import 'package:flutter/material.dart';

class ChangeChatBoxScreen extends StatelessWidget {
  ChangeChatBoxScreen({super.key, required this.onColorSelected});

  final Function(Color) onColorSelected;
  List<ChatBoxCardModel> ChatBoxColors = [
    ChatBoxCardModel(color: Color(0xFF6C52FF)),
    ChatBoxCardModel(color: Color(0xFFC5048E)),
    ChatBoxCardModel(color: Color(0xFFFF5852)),
    ChatBoxCardModel(color: Color(0xFFFFDD00)),
    ChatBoxCardModel(color: Color(0xFF009022)),
    ChatBoxCardModel(color: Color(0xFF00A4B6)),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(gradient: primaryGradientColor),
                height: 92,
                width: double.infinity,

                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Change ChatBox',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: ChatBoxColors.length,
                  itemBuilder: (context, index) {
                    return ChatBoxCard(
                      chatBoxCard: ChatBoxColors[index],
                      onTap: () {
                        onColorSelected(ChatBoxColors[index].color);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
