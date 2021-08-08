import 'package:bling/core/client.dart';
import 'package:bling/core/models/user.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
      return ListView(
        children: [
          Text("Username: " + Client.user.username)
        ],
      );
  }
}
