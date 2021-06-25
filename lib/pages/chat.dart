import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String id;
  Chat(this.id);

  @override
  _ChatState createState() => _ChatState();
}

class Message{
  int time;
  String text;
  String author;
  bool isClients;
  Message(this.text, this.author, this.time, this.isClients);
}

class _ChatState extends State<Chat> {

  AppBar _chatAppBar(String title) => AppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.close),),
    title: Text(title),
    centerTitle: true,
  );

  Widget get _textField => Expanded(
    child: Container(
      height: 26.0,
      margin: EdgeInsets.only(left: 15.0),
      child: TextField(
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

  Widget messageBuilder(Message message){
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: message.isClients ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.isClients ? SizedBox() : CircleAvatar(backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"), radius: 20.0),
                Container(
                  child: Text(message.text, style: TextStyle(color: message.isClients ? Colors.white : Colors.black)),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width/2+20,
                  ),
                  margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0),
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(color: message.isClients ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(10.0)),

                ),
                message.isClients ? CircleAvatar(backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"), radius: 20.0) : SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _chatAppBar(widget.id),
      body: Padding(
        padding: EdgeInsets.only(bottom: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            messageBuilder(new Message("Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet", "johndoe", 10, true)),
            messageBuilder(new Message("Lorem ipsum dolor sit amet", "johndoe", 10, true)),
            messageBuilder(new Message("Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet", "johndoe", 10, false)),
            messageBuilder(new Message("Lorem ipsum dolor sit amet", "johndoe", 10, true)),
            messageBuilder(new Message("Lorem ipsum dolor sit amet", "johndoe", 10, false)),
            messageBuilder(new Message("Lorem ipsum dolor sit amet", "johndoe", 10, false)),
            //Input field
            Divider(
              height: 5.0,
            ),
            Row(
              children: [
                _textField,
                SizedBox(
                  width: 35.0,
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.send)),
                ),
                SizedBox(
                  width: 40.0,
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_voice)),
                )
              ],
            )

          ],
        ),
      )
    );
  }
}

