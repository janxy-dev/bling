import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/themes.dart';
import 'core/client.dart';

void main() {
  runApp(Bling());
}

class Bling extends StatefulWidget {
  @override
  _BlingState createState() => _BlingState();
}

class _BlingState extends State<Bling> {

  @override
  void initState(){
    super.initState();
    Client.connect();
    Themes.themes.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
      themeMode: Themes.themeMode,
      darkTheme: Themes.darkTheme,
    );
  }
}




