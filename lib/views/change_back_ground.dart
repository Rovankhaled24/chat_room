import 'package:chat_room/const.dart';
import 'package:chat_room/models/card_model.dart';
import 'package:chat_room/widgets/background_card.dart';

import 'package:flutter/material.dart';


class ChangeBackGroundScreen extends StatelessWidget {
  ChangeBackGroundScreen({super.key, required this.onBackgroundSelected});
  static String id = 'changebackground';
  final Function(String) onBackgroundSelected;

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
                            'Change Background',
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: GridView.builder(
                    itemCount: backgrounds.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 30,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      return ChangeCard(
                        cardModel: backgrounds[index],
                        onTap: () {
                          
                          onBackgroundSelected(backgrounds[index].image);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
