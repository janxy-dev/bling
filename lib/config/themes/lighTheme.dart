import 'package:flutter/material.dart';

ThemeData getLightTheme() {
  return ThemeData(
    primaryColor: Colors.lightBlue,
    accentColor: Colors.white,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.black),
      headline2: TextStyle(color: Colors.black),
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
    ),
  );
}