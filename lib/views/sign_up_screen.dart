import 'package:chat_room/helper/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';
class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});
  static String id = 'signuppage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;
  String? username;
  String? password;
  bool isloading = false;
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isloading,
        child: Scaffold(
          body: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      width: 700,
                      height: 320,
                      child: Image.asset('assets/Group discussion-amico.png'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        validator: (data) {
                          if (data!.isEmpty) {
                            return ' the data is required';
                          }
                        },
                        onChanged: (value) {
                          username = value;
                        },
                        decoration: InputDecoration(
                          hintText: '  user name ',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 25,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        validator: (data) {
                          if (data!.isEmpty) {
                            return ' the data is required';
                          }
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          hintText: '  Email ',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 25,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                     
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        validator: (data) {
                          if (data!.isEmpty) {
                            return ' the data is required';
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          hintText: '  Password ',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 25,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
  if (formkey.currentState!.validate()) {
    isloading = true;
    setState(() {});
    try {
     
      if (username == null) {
        showsnackbar(context, 'Please enter your name');
        return;
      }

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      final user = credential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': email,
          'name': username,
          'password':password,
        });

        showsnackbar(context, 'Success');
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showsnackbar(context, 'The email already exists');
      } else if (e.code == 'weak-password') {
        showsnackbar(context, 'Weak password');
      } else {
        showsnackbar(context, 'Registration failed: ${e.message}');
      }
    } finally {
      isloading = false;
      setState(() {});
    }
  }
},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD6A4DE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ), child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),



                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(' login '),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

 
}
