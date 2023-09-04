import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultTextFormFiled({
  required TextInputType type,
  // required Function validate,
  required String labelText,
  required IconData prefixIcon,
}) =>
    TextFormField(
        // controller: controller,

        // validator: (s) {
        //   validate(s);
        // },
        keyboardType: type,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
        ));

Widget defaultButtonInLogin({
  required double width,
  required Color background,
  required Function function,
  String? text,
  bool upperCase = true,
}) =>
    Container(
      width: width,
      height: 55,
      color: background,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          upperCase ? text!.toUpperCase() : text!.toLowerCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
    );

Widget defaultText({
  required String text,
  required double fontSize,
  Color? color,
}) =>
    Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color),
    );



Widget buttonSingInGoogle({
  required Function function,
}) => MaterialButton(
  onPressed: () {
    function();
  },
  padding: EdgeInsets.symmetric(vertical: 5.0),
  shape: ContinuousRectangleBorder(
    side: BorderSide(width: 0.5, color: Colors.grey),
  ),
  // onPressed: () {
  // },
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/images/google.png',
          fit: BoxFit.contain,
          width: 40.0,
          height: 40.0),
      defaultText(
          text: 'Google',
          fontSize: 25.0,
          color: Colors.black)
    ],
  ),
);