import 'package:bling/core/client.dart';
import 'package:bling/core/models/user.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel user = UserModel();
  @override
  Widget build(BuildContext context) {
    Client.fetch("fetchLocalUser", (json) {
      setState(() {
        user = UserModel.fromJson(json);
      });
    });
      return ListView(
        children: [
          Text("Username: " + user.username)
        ],
      );
  }
}
