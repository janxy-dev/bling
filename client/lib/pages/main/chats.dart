import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/core/models/message.dart';
import 'package:bling/core/storage.dart';
import 'package:bling/widgets/chat_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../local_notifications.dart';
import '../chat.dart';

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
  GroupModel? currentGroup;
  @override
  void initState() {
    super.initState();
    if(widget.groups.isEmpty){
      _fetchGroups();
      Client.socket.on("message", (data) {
        var json = data[0];
        if(json == null) json = data;
        else data[1](Client.token); //send ack that message is delivered
        MessageModel message = MessageModel.fromJson(json);
        Storage.addMessage(message);
        // fetch group if doesn't exist
        if(widget.groups[message.groupUUID] == null){
          Client.fetch("fetchGroup", args: [json["groupUUID"]], onData: (data){
            GroupModel group = GroupModel.fromJson(data);
            group.messages.add(message);
            widget.groups.putIfAbsent(data["groupUUID"], () => group);
            if(this.mounted) setState(() {}); //refresh
          });
          return;
        }
        //show local notification
        if(currentGroup != null && currentGroup?.groupUUID != message.groupUUID){
          GroupModel group = widget.groups[message.groupUUID]!;
          LocalNotifications.showMessageNotification(group.name, group.groupUUID, message.sender, message.message);
        }
        if(this.mounted) {
          setState(() {
            widget.groups[message.groupUUID]?.messages.add(
                MessageModel.fromJson(json));
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
          children: [...widget.groups.values.map((e) => ChatBanner(e, (){
            Navigator.of(context).pushNamed("/chat", arguments: ChatArguments(e, (){setState(() {}); currentGroup = null;}));
            currentGroup = e;
          }))].reversed.toList(),
        )
      ],
    );
  }
}