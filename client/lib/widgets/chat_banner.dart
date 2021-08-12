import 'package:bling/core/models/group.dart';
import 'package:bling/pages/chat.dart';
import 'package:bling/pages/main/chats.dart';
import 'package:flutter/material.dart';

class ChatBanner extends StatefulWidget {
  final GroupModel group;
  ChatBanner(this.group) : super(key: ValueKey(group.groupUUID));

  @override
  _ChatBannerState createState() => _ChatBannerState();
}

class _ChatBannerState extends State<ChatBanner> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed("/chat", arguments: ChatArguments(widget.group, (){setState(() {});})),
      child: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                    backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"), radius: 25.0),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
                height: 70,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 35-7, top: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.group.name, style: TextStyle(fontSize: 14)),
                      Text(widget.group.messages.isNotEmpty ? widget.group.messages.last.message : "", style: TextStyle(fontSize: 12))
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
