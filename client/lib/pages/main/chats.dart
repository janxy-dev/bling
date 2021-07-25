import 'dart:convert';

import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/widgets/chat_banner.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<GroupModel> groups = <GroupModel>[];
  void fetchGroups(){
    Client.fetch("fetchGroups", (json) {
      if(this.mounted && json != null){
        setState(() {
          //Group isn't sent in a list if there is only 1 group
          if(json[0] == null) groups = [GroupModel.fromJson(json)];
          else{
            for(int i = 0; i<json.length; i++){
              groups.add(GroupModel.fromJson(json[i]));
            }
          }
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    fetchGroups();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Divider(),
        Column(
          children: [...groups.map((e) => ChatBanner(e))],
        )
      ],
    );
  }
}