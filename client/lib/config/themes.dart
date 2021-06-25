import 'package:bling/config/themes/darkTheme.dart';
import 'package:bling/config/themes/lighTheme.dart';
import 'package:flutter/material.dart';

class Themes extends ChangeNotifier{
  static Themes themes = Themes();
  static bool _isDarkMode = false;
  static ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  void toggleTheme(){
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  static ThemeData lightTheme = getLightTheme();
  static ThemeData darkTheme = getDarkTheme();
}

