import 'package:flutter/material.dart';
import 'package:bling/core/client.dart';
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Client.prefs == null){
      Client.loadPrefs().then((_)=>Navigator.of(context).pushNamed('/'));
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
    );
  }
}