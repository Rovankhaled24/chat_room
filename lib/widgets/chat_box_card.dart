import 'package:chat_room/const.dart';
import 'package:chat_room/models/chat_box_card_model.dart';
import 'package:flutter/material.dart';

class ChatBoxCard extends StatelessWidget {
  ChatBoxCard({super.key, required this.chatBoxCard,  this.onTap});
  final ChatBoxCardModel chatBoxCard;
  final VoidCallback? onTap;
  final List<ChatBoxCardModel> ChatBoxColors = [
    ChatBoxCardModel(color: Color(0xFF6C52FF)),
    ChatBoxCardModel(color: Color(0xFFC5048E)),
    ChatBoxCardModel(color: Color(0xFFFF5852)),
    ChatBoxCardModel(color: Color(0xFFFFDD00)),
    ChatBoxCardModel(color: Color(0xFF009022)),
    ChatBoxCardModel(color: Color(0xFF00A4B6)),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 209,
      width: 173,
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                width: 109,
                height: 42,
                decoration: BoxDecoration(
                  color:chatBoxCard.color ,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Center(
                    child: Text(
                      'Hi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 38,
                width: 146,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF8302AA),
                      offset: Offset(0, 4),
                      blurRadius: 0,
                      spreadRadius: BorderSide.strokeAlignOutside,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  gradient: primaryGradientColor,
                ),
                child: GestureDetector(
                  onTap: onTap,
                  child: Center(
                    child: Text(
                      'Change',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
