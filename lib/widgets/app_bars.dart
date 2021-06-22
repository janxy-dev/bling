import 'package:bling/config/routes.dart';
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

Widget NavbarBtn(BuildContext context, String name, int page){
  return GestureDetector(
    onTap: (){
      RouteGenerator.pageCtrl.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.ease);
    },
    child: Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Text(
          name, style: TextStyle(color: Colors.grey, fontSize: 15.0, decoration: TextDecoration.none)
      ),
    ),
  );
}

class PrimaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  int page = 0;
  PrimaryAppBar(){
    page = RouteGenerator.pageCtrl.initialPage;
  }
  @override
  _PrimaryAppBarState createState() => _PrimaryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  bool listenerAdded = false;
  @override
  Widget build(BuildContext context) {
    if(!listenerAdded){
      RouteGenerator.pageCtrl.addListener(() {
        int page = 0;
        if(RouteGenerator.pageCtrl.page! > 1.5) page = 2;
        else if (RouteGenerator.pageCtrl.page! < 0.5) page = 0;
        else page = 1;
        if(widget.page == page) return;
        setState(() => widget.page = page);
      });
      listenerAdded = true;
    }
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

class  SecondaryAppBar extends StatefulWidget {
  double margin = 0.0;
  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {

  bool listenerAdded = false;

  @override
  Widget build(BuildContext context) {
    if(!listenerAdded){
      RouteGenerator.pageCtrl.addListener(() {
        setState(() {
          var multiplier = 1.0-RouteGenerator.pageCtrl.page!.toDouble();
          widget.margin = -128*multiplier;
        },);
      });
      listenerAdded = true;
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[50],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavbarBtn(context, "FRIENDS", 0),
                NavbarBtn(context, "CHATS", 1),
                NavbarBtn(context, "PROFILE", 2),
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