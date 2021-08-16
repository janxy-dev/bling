import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/core/models/message.dart';
import 'package:bling/core/storage.dart';
import 'package:flutter/material.dart';

class ChatArguments{
  final GroupModel group;
  final Function updateParent;
  ChatArguments(this.group, this.updateParent){
    updateParent();
  }
}

class Chat extends StatefulWidget {
  final ChatArguments args;
  GroupModel get group => args.group;
  Function get updateParent => args.updateParent;
  Chat(this.args);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  AppBar _chatAppBar(String title) => AppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.close),),
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
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: isClients ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isClients ? SizedBox() : avatar,
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !isClients && message.sender.isNotEmpty ? Text(message.sender, style: TextStyle(fontWeight: FontWeight.bold)) : SizedBox(),
                      Text(message.message, style: TextStyle(color: isClients ? Colors.white : Colors.black))
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width/2+20,
                  ),
                  margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0),
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(color: isClients ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(10.0)),

                ),
                isClients ? avatar : SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }

  void seenMessages(){
    Storage.seenMessages(widget.group);
    List<MessageModel> msgs = widget.group.messages;
    for(int i = 0; i<msgs.length; i++){
      msgs[i].seen = true;
    }
  }
  void _onMsg(json){
    Future.delayed(Duration(milliseconds: 1), (){
      if(this.mounted){
        setState(() {}); //update state on message
        seenMessages();
        widget.updateParent();
      }
    });
  }
  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    seenMessages();
    Client.socket.on("message", _onMsg);
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
    Client.socket.off("message", _onMsg);
  }
  @override
  Widget build(BuildContext context) {
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
              children: widget.group.messages.map((e) => messageBuilder(e)).toList().reversed.toList(),
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

