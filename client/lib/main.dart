import 'package:bling/widgets/restart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'config/routes.dart';
import 'config/themes.dart';
import 'core/client.dart';
import 'core/storage.dart';
import 'local_notifications.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Storage.load();
  Client.token = Storage.prefs.getString("token") ?? "";
  runApp(RestartWidget(child: Bling()));
}

class Bling extends StatefulWidget {
  @override
  _BlingState createState() => _BlingState();
}

class _BlingState extends State<Bling> {

  void updateState(){
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    Client.initFirebase();
    LocalNotifications.init();
    Themes.themes.addListener(updateState);
    Routes.init();
  }

  @override
  void dispose() {
    super.dispose();
    Themes.themes.removeListener(updateState);
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




