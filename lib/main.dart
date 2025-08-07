import 'package:chat_room/firebase_options.dart';
import 'package:chat_room/views/change_back_ground.dart';
import 'package:chat_room/views/home_screen.dart';
import 'package:chat_room/views/login_screen.dart';
import 'package:chat_room/views/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, 
     initialRoute:LoginScreen.id,
    routes: {
     LoginScreen.id:(context)=>LoginScreen(),
     SignUpPage.id:(context)=>SignUpPage(),
     HomeScreen.id:(context)=>HomeScreen(),
   
 

    },
    
    );
  }
}
