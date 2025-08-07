import 'package:chat_room/helper/show_snack_bar.dart';
import 'package:chat_room/views/home_screen.dart';
import 'package:chat_room/views/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'loginview';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  String? username;
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
                          'Sign in',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Email ',
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
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Password ',
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
                            await SignInUser();
                            showsnackbar(context, 'success');
                            isloading = false;
                            setState(() {});
                            Navigator.pushNamed(
                              context,
                              HomeScreen.id,
                              arguments: {'email': email, 'username': username},
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              showsnackbar(context, 'user not found');
                            } else if (e.code == 'wrong-password') {
                              showsnackbar(context, 'wrong password');
                            } else {
                              showsnackbar(
                                context,
                                'Login failed: ${e.message}',
                              );
                            }
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
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('don\'t have an account?'),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUpPage();
                                },
                              ),
                            );
                          },
                          child: Text(' Register '),
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

  Future<void> SignInUser() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
