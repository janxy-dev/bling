import 'package:bling/config/routes.dart';
import 'package:bling/core/client.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}
class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Routes.isLoading = true;
    Client.connect(() {
      if (Client.token.isNotEmpty) {
        if (Routes.isLoading) {
          Client.fetchGroups((){
            Routes.isLoading = false;
            Navigator.of(context).pushNamed("/");
          });
        }
        Client.fetchUser();
      }
      else{ //->/->AuthPage
        Routes.isLoading = false;
        Navigator.of(context).pushNamed("/");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}

