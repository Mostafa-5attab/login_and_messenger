import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/copmonentssss/copmonentsRegister.dart';
import 'package:messenger/main_screens/chat_screen.dart';
import 'package:messenger/Register/RegisterGoogle.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String name = ''; // تهيئة باستخدام قيمة افتراضية
  late String email = ''; // تهيئة باستخدام قيمة افتراضية
  late String password = ''; // تهيئة باستخدام قيمة افتراضية
  bool _showSpinner = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;
  bool showPassword = true;
  String _emailText = 'Please use a valid email';
  String _passwordText = 'Please use a strong password';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> names() async {
    setState(() {
      _wrongEmail = false;
      _wrongPassword = false;
    });
    try {
      if (RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
              .hasMatch(email) &&
          password.length >= 6) {
        setState(() {
          _showSpinner = true;
        });
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (newUser != null) {
          Navigator.pushNamed(context, ChatScreen.id);
        }
      } else {
        setState(() {
          if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                  .hasMatch(email) &&
              password.length < 6) {
            _wrongEmail = true;
            _wrongPassword = true;
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _wrongEmail = true;
        if (e.code == 'email-already-in-use') {
          _emailText = 'The email address is already in use by another account';
        }
      });
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        color: Colors.blueAccent,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 200.0, bottom: 20.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  defaultText(text: 'Register', fontSize: 50.0),
                  Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          labelText: 'Full Name',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _wrongEmail ? _emailText : null,
                            prefixIcon: Icon(Icons.email)),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        obscureText: showPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: _wrongPassword ? _passwordText : null,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: Icon(showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                  defaultButtonInLogin(
                    width: double.infinity,
                    background: Color(0xff447def),
                    function: () async {
                      names();
                    },
                    text: 'Register',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buttonSingInGoogle(function: () {
                          onGoogleSignIn(context);
                        }),
                      ),
                      SizedBox(width: 20.0),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      defaultText(
                          text: 'Already have an account?', fontSize: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/LoginPage');
                        },
                        child: defaultText(
                            text: "Sign In",
                            fontSize: 10.0,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
