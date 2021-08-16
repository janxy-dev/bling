import 'package:bling/core/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bling/core/client.dart';
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(!Storage.isLoaded){
      Storage.load().then((value) {
        Client.token = Storage.prefs.getString("token") ?? "";
        if(Client.token.isNotEmpty){
          Client.sendFirebaseToken();
          Client.fetchUser();
        }
        Navigator.of(context).pushNamed('/');
      });
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
    );
  }
}