import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:messenger/LogIN/LoginGoogle.dart';
import 'package:messenger/copmonentssss/copmonentsRegister.dart';
import 'package:messenger/Register/RegisterPage.dart';
import 'package:messenger/main_screens/chat_screen.dart';
import 'package:messenger/results_screen/ForgotPassword.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

bool showSpinner = false;

class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;
  bool _wrongEmail = false;
  bool _wrongPassword = false;
  late User _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String emailText = 'Email doesn\'t match';
  String passwordText = 'Password doesn\'t match';
  Future<User> _handleSignIn() async {
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      final GoogleSignInAuthentication? googleAuth =
          await _googleSignIn.currentUser!.authentication;
      if (googleAuth != null) {
        User user = _auth.currentUser!;
        return user;
      } else {
        throw Exception("Failed to get Google Authentication");
      }
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User user = userCredential.user!;
        return user;
      } else {
        throw Exception("Failed to get Google Authentication");
      }
    }
  }

  void onGoogleSignIn(BuildContext context) async {
    showSpinner = true;

    User userCredential = await _handleSignIn();

    showSpinner = false;

    if (userCredential != null) {
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    }
  }

  Future nn() async {
    setState(() {
      showSpinner = true;
    });
    try {
      setState(() {
        _wrongEmail = false;
        _wrongPassword = false;
      });
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final newUser = userCredential.user;
      if (newUser != null) {
        await _auth.signOut(); // تسجيل الخروج من الحساب السابق
        Navigator.pushNamed(context, ChatScreen.id);
      }
    } catch (e) {
      print(e.toString());
      if (e.toString() == 'ERROR_WRONG_PASSWORD') {
        setState(() {
          _wrongPassword = true;
        });
      } else {
        setState(() {
          emailText = 'User doesn\'t exist';
          passwordText = 'Please check your email';
          _wrongPassword = true;
          _wrongEmail = true;
        });
      }
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.deepOrange])),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          color: Colors.blueAccent,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    defaultText(
                      text: 'Login',
                      fontSize: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultText(
                            text:
                                'Welcome back,\nplease login \nto your account \n',
                            fontSize: 30.0)
                      ],
                    ),
                    Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            errorText: _wrongEmail ? emailText : null,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            errorText: _wrongPassword ? passwordText : null,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, ForgotPassword.id);
                            },
                            child: defaultText(
                                fontSize: 20,
                                text: 'Forgot Password?',
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      color: const Color(0xff447def),
                      onPressed: () {
                        nn();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: 1.0,
                            width: 60.0,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'Or',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: 1.0,
                            width: 60.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            color: Colors.white,
                            shape: const ContinuousRectangleBorder(
                              side: BorderSide(width: 0.5, color: Colors.grey),
                            ),
                            onPressed: () {
                              setState(() {
                                onGoogleSignIn(context);
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/google.png',
                                    fit: BoxFit.contain,
                                    width: 40.0,
                                    height: 40.0),
                                const Text(
                                  'Google',
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(fontSize: 10.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterPage.id);
                          },
                          child: const Text(
                            ' Sign Up',
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
