import 'dart:convert';

import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/core/models/message.dart';
import 'package:bling/widgets/chat_banner.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  final Map<String, GroupModel> groups;
  ChatsPage(this.groups);
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  void _fetchGroups(){
    Client.fetch("fetchAllGroups", onData: (json) {
      if(this.mounted && json != null){
        setState(() {
          //Group isn't sent in a list if there is only 1 group
          if(json[0] == null){
            GroupModel model = GroupModel.fromJson(json);
            widget.groups.putIfAbsent(model.groupUUID, () => model);
          }
          else{
            for(int i = 0; i<json.length; i++){
              GroupModel model = GroupModel.fromJson(json[i]);
              widget.groups.putIfAbsent(model.groupUUID, () => model);
            }
          }
          //add messages to groups
          List<MessageModel> msgs = Client.user.messages;
          for(int i = 0; i<msgs.length; i++){
            widget.groups[msgs[i].groupUUID]?.messages.add(msgs[i]);
          }
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    if(widget.groups.isEmpty){
      _fetchGroups();
      Client.socket.on("message", (json) {
        if(this.mounted){
          setState(() {
            if(widget.groups[json["groupUUID"]] == null){ // fetch group if doesn't exist
              Client.fetch("fetchGroup", args: [json["groupUUID"]], onData: (data){
                GroupModel group = GroupModel.fromJson(data);
                group.messages.add(MessageModel.fromJson(json));
                widget.groups.putIfAbsent(data["groupUUID"], () => group);
                setState(() {}); //refresh
              });
            }
            else widget.groups[json["groupUUID"]]?.messages.add(MessageModel.fromJson(json));
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Divider(),
        Column(
          children: [...widget.groups.values.map((e) => ChatBanner(e))].reversed.toList(),
        )
      ],
    );
  }
}