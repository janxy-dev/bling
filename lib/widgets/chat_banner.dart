import 'package:flutter/material.dart';

class ChatBanner extends StatefulWidget {
  final ValueKey key;
  ChatBanner(this.key) : super(key: key);

  @override
  _ChatBannerState createState() => _ChatBannerState();
}

class _ChatBannerState extends State<ChatBanner> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed("/chat", arguments: widget.key.value),
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
                      Text(widget.key.value, style: TextStyle(fontSize: 14)),
                      Text("Lorem ipsum dolor sit amet...", style: TextStyle(fontSize: 12))
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
