import 'package:bling/config/themes/darkTheme.dart';
import 'package:bling/config/themes/lighTheme.dart';
import 'package:bling/core/client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themes extends ChangeNotifier{
  static Themes themes = Themes();
  static bool get isDarkMode => Client.prefs == null ? false : Client.prefs?.getBool("darkMode") ?? false;
  static ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
  void toggleTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", isDarkMode);
    notifyListeners();
  }

  static ThemeData lightTheme = getLightTheme();
  static ThemeData darkTheme = getDarkTheme();
}

