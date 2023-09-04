
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/main_screens/chat_screen.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential?> _handleSignIn() async {
  UserCredential? userCredential;
  // التحقق من تسجيل الدخول باستخدام حساب Google
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  if (googleUser != null) {
    final GoogleSignInAuthentication? googleAuth =
    await googleUser.authentication;
    if (googleAuth != null) {
      userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );
    } else {
      // التعامل مع حالة googleAuth == null هنا
      print("Google authentication failed.");
    }
  } else {
    // التعامل مع حالة googleUser == null هنا
    print("Google sign-in failed.");
  }

  return userCredential;
}

void onGoogleSignIn(BuildContext context) async {
  UserCredential? userCredential = await _handleSignIn();
  if (userCredential != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(),
      ),
    );
  }
}
