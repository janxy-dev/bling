import 'package:bling/widgets/restart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/themes.dart';
import 'core/client.dart';
import 'local_notifications.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RestartWidget(child: Bling()));
}

class Bling extends StatefulWidget {
  @override
  _BlingState createState() => _BlingState();
}

class _BlingState extends State<Bling> {

  @override
  void initState(){
    super.initState();
    Client.initFirebase();
    Client.connect();
    Themes.themes.addListener(() {
      setState(() {});
    });
    Routes.init();
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




