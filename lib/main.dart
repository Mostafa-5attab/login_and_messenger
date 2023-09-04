import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart'; // استيراد حزمة Firebase
import 'package:messenger/LogIN/LoginPage.dart';
import 'package:messenger/Register/RegisterPage.dart';
import 'package:messenger/main_screens/chat_screen.dart';
import 'package:messenger/results_screen/ForgotPassword.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase هنا
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Abel'),
      initialRoute: RegisterPage.id,
      routes: {
        RegisterPage.id: (context) => RegisterPage(),
        LoginPage.id: (context) => LoginPage(),
        ForgotPassword.id: (context) => ForgotPassword(),
        ChatScreen.id: (context) => ChatScreen(),
        // Done.id: (context) => Done(),
      },
    );
  }
}
