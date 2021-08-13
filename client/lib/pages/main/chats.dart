import 'dart:convert';

import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/core/models/message.dart';
import 'package:bling/core/storage.dart';
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
          for(int i = 0; i<widget.groups.keys.length; i++){
            String groupUUID = widget.groups.keys.elementAt(i);
            Storage.getMessagesCount(groupUUID).then((msgCount) {
              Storage.getMessages(groupUUID, msgCount, 15).then((value) {
                widget.groups[groupUUID]!.messages.addAll(value);
                setState(() {});
              });
            });
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
      Client.socket.on("message", (data) {
        var json = data[0];
        if(json == null) json = data;
        else data[1](Client.token); //send ack that message is delivered
        Storage.addMessage(MessageModel.fromJson(json));
        if(this.mounted){
          setState(() {
            // fetch group if doesn't exist
            if(widget.groups[json["groupUUID"]] == null){
              Client.fetch("fetchGroup", args: [json["groupUUID"]], onData: (data){
                GroupModel group = GroupModel.fromJson(data);
                MessageModel msg = MessageModel.fromJson(json);
                group.messages.add(msg);
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