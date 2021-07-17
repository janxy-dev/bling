import 'package:bling/core/client.dart';
import 'package:flutter/material.dart';
class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: ()=>Navigator.of(context).pushNamed("/login"), child: Text("Log in")),
            TextButton(onPressed: ()=>Navigator.of(context).pushNamed("/signup"), child: Text("Sign up")),
            ]
      ),
    ));
  }
}