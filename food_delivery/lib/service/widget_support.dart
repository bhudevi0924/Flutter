import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle headlineTextStyles() {
    return TextStyle(
      color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold
    );
  }

  static TextStyle simpleTextStyles() {
    return TextStyle(
      color: Colors.black, fontSize: 16.0
    );
  }

  static TextStyle whiteTextFieldStyles() {
    return TextStyle(
      color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold
    );
  }

  static TextStyle boldTextFieldStyles() {
    return TextStyle(
      color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold
    );
  }

  static TextStyle priceTextFieldStyles() {
    return TextStyle(
      color: Colors.black54, fontSize: 20.0, fontWeight: FontWeight.bold
    );
  }

  static TextStyle signupTextFieldStyles() {
    return TextStyle(
      color: Colors.black54, fontSize: 16.0, fontWeight: FontWeight.bold
    );
  }

  static MaterialAccentColor primaryColor=Colors.amberAccent;
}