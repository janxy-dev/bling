import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget SearchBtn(){
  return GestureDetector(
    child: Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Icon(Icons.search),
    ),
  );
}

Widget SettingsBtn(BuildContext context){
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed("/settings");
    },
    child: Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Icon(Icons.settings),
    ),
  );
}

class PrimaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  PageController pageCtrl;
  int page = 0;
  PrimaryAppBar(this.pageCtrl){
    page = pageCtrl.initialPage;
  }
  @override
  _PrimaryAppBarState createState() => _PrimaryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  @override
  Widget build(BuildContext context) {
    widget.pageCtrl.addListener(() {
      setState(() {
        if(widget.pageCtrl.page! > 1.5) widget.page = 2;
        else if (widget.pageCtrl.page! < 0.5) widget.page = 0;
        else widget.page = 1;
      });
    });
    return AppBar(
        title: Text("Bling"),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [ widget.page != 0 ? SearchBtn() : Container(width: 0, height: 0),
          SettingsBtn(context)
        ]
    );
  }
}

Widget NavbarBtn(BuildContext context, String name){
  return GestureDetector(
    child: Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Text(
          name, style: TextStyle(color: Colors.grey, fontSize: 15.0, decoration: TextDecoration.none)
      ),
    ),
  );
}

class  SecondaryAppBar extends StatefulWidget {

  PageController pageCtrl;
  double margin = 0.0;
  SecondaryAppBar(this.pageCtrl);

  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {

  @override
  Widget build(BuildContext context) {
    widget.pageCtrl.addListener(() {
      setState(() {
        var multiplier = 1.0-widget.pageCtrl.page!.toDouble();
        widget.margin = -128*multiplier;
      });
    });
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[50],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavbarBtn(context, "FRIENDS"),
                NavbarBtn(context, "CHATS"),
                NavbarBtn(context, "PROFILE"),
              ],
            ),
              Container(
                transform: Matrix4.translationValues(widget.margin, 0.0, 0.0),
                width: 60.0,
                height: 5.0,
                color: Colors.grey[300],
              ),
          ]
        )
    );
  }
}

AppBar SettingsAppBar(title){
  return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true
  );
}