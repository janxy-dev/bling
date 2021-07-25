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
  void initState() {
    super.initState();
    Client.fetch("fetchLocalUser", (json) {
      if(this.mounted){
        setState(() {
          user = UserModel.fromJson(json);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
      return ListView(
        children: [
          Text("Username: " + user.username)
        ],
      );
  }
}
