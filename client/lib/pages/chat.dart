import 'dart:ffi';

import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/core/models/message.dart';
import 'package:bling/core/storage.dart';
import 'package:flutter/material.dart';

import 'main/chats.dart';
class ChatArguments{
  GroupModel group;
  Function onLeave;
  ChatArguments(this.group, {required this.onLeave});
}
class Chat extends StatefulWidget {
  final ChatArguments args;
  GroupModel get group => args.group;
  Function get onLeave => args.onLeave;
  Chat(this.args);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  AppBar _chatAppBar(String title) => AppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(onPressed: () { Navigator.pop(context); widget.onLeave();}, icon: Icon(Icons.close),),
    title: Text(title),
    centerTitle: true,
  );

  TextEditingController textCtrl = TextEditingController();
  Widget get _textField => Expanded(
    child: Container(
      height: 26.0,
      margin: EdgeInsets.only(left: 15.0),
      child: TextField(
        controller: textCtrl,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),

        ),
      ),
    ),
  );

  Widget messageBuilder(MessageModel message){
    bool isClients = message.sender == Client.user.username;
    Widget avatar = CircleAvatar(backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"), radius: 20.0);
    if(message.sender.isEmpty) avatar = SizedBox();
    return Container(
      padding: EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: isClients ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isClients ? SizedBox() : avatar,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        !isClients && message.sender.isNotEmpty ? Text(message.sender, style: TextStyle(fontWeight: FontWeight.bold)) : SizedBox(),
                        Text(message.message, style: TextStyle(color: isClients ? Colors.white : Colors.black)),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minWidth: 40,
                      maxWidth: MediaQuery.of(context).size.width/2+20,
                    ),
                    margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0),
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(color: isClients ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(10.0)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, right: 7),
                    child: Text(
                      message.getFormattedTime(), style: TextStyle(fontSize: 9),),
                  )
                ],
              ),
              isClients ? avatar : SizedBox()
            ],
          ),
        ],
      ),
    );
  }
  void onMsg(json){
    if(this.mounted){
      setState(() {});//update state on message
    }
  }
  void onUserFetch(msgs){
    setState(() {});
      for(int i = 0; i<msgs.length; i++){
        MessageModel msg = MessageModel.fromJson(msgs[i]);
        if(msg.groupUUID == widget.group.groupUUID){
          widget.group.messages.firstWhere((e) => e.uuid == msg.uuid).seen = true;
        }
      }
  }
  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    Client.onUserFetch.add(onUserFetch);
    Client.socket.on("message", onMsg);
    bool buffering = false;
    scrollController.addListener(() {
        if(scrollController.position.extentAfter < 500 && !buffering){
            buffering = true;
            Storage.getMessages(widget.group.groupUUID, widget.group.messages.first.id-1, 10).then((value) {
              widget.group.messages.insertAll(0, value);
              setState(() {});
              buffering = false;
            });
        }
      });
    }
  @override
  void dispose() {
    super.dispose();
    Client.socket.off("message", onMsg);
    Client.onUserFetch.remove(onUserFetch);
  }
  @override
  Widget build(BuildContext context) {
    DateTime? date;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _chatAppBar(widget.group.name),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Messages
          Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.only(bottom: 10.0),
              controller: scrollController,
              children: widget.group.messages.map((e) {
                if(date == null || !(e.time.day == date!.day && e.time.month == date!.month && e.time.year == date!.year)){
                  date = e.time;
                  String formattedDate = e.getFormattedDate();
                  if(formattedDate.length == 5) formattedDate = "Today";
                  return Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(formattedDate, style: TextStyle(fontSize: 12),)),
                      messageBuilder(e)
                    ],
                  );
                }
                return messageBuilder(e);
              }).toList().reversed.toList(),
            ),
          ),
          //Input field
          Divider(
            height: 5.0,
          ),
          Row(
            children: [
              _textField,
              SizedBox(
                width: 35.0,
                child: IconButton(onPressed: (){
                  Client.sendMessage(textCtrl.text, widget.group.groupUUID);
                  textCtrl.clear();
                }, icon: Icon(Icons.send)),
              ),
              SizedBox(
                width: 40.0,
                child: IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_voice)),
              )
            ],
          ),
        ],
      )
    );
  }
}

