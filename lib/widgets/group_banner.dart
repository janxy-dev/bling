import 'package:flutter/material.dart';

class GroupBanner extends StatefulWidget {
  const GroupBanner({Key? key}) : super(key: key);

  @override
  _GroupBannerState createState() => _GroupBannerState();
}

class _GroupBannerState extends State<GroupBanner> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
                  backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"), radius: 25.0),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
            height: 70,
            child: Padding(
              padding: EdgeInsets.only(bottom: 35-7, top: 6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("John Doe", style: TextStyle(fontSize: 14)),
                  Text("Lorem ipsum dolor sit amet...", style: TextStyle(fontSize: 12))
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
