import 'package:bling/config/themes/darkTheme.dart';
import 'package:bling/config/themes/lighTheme.dart';
import 'package:bling/core/storage.dart';
import 'package:flutter/material.dart';

class Themes extends ChangeNotifier{
  static Themes themes = Themes();
  static bool get isDarkMode => !Storage.isLoaded ? false : Storage.prefs.getBool("darkMode") ?? false;
  static ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
  void toggleTheme() async{
    Storage.prefs.setBool("darkMode", !isDarkMode);
    print(isDarkMode);
    notifyListeners();
  }

  static ThemeData lightTheme = getLightTheme();
  static ThemeData darkTheme = getDarkTheme();
}

