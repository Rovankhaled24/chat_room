import 'package:chat_room/const.dart';
import 'package:chat_room/models/card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeCard extends StatelessWidget {
  ChangeCard({super.key, required this.cardModel, this.onTap});
  final CardModel cardModel;
  final VoidCallback? onTap;
  final List<CardModel> backgrounds = [
    CardModel(image: 'assets/bg2.jpg'),
    CardModel(image: 'assets/bg5.jpg'),
    CardModel(image: 'assets/bg6.jpg'),
    CardModel(image: 'assets/bg7.jpg'),
    CardModel(image: 'assets/bg8.jpg'),
      CardModel(image: 'assets/bg9.jpg'),
    
  ];
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
                  width: 130, 
                  height: 125, 
                  decoration: BoxDecoration(
                   
                    image: DecorationImage(
                image: AssetImage(cardModel.image),
                fit: BoxFit.cover,
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
    );
  }
}
