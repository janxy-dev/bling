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

class PrimaryAppBar extends StatefulWidget {
  PageController pageCtrl;
  bool searchbar = true;
  PrimaryAppBar(this.pageCtrl);
  @override
  _PrimaryAppBarState createState() => _PrimaryAppBarState();
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  @override
  Widget build(BuildContext context) {
    widget.pageCtrl.addListener(() {
      if (widget.pageCtrl.page! > 1.5){
        setState(() {
          widget.searchbar = false;
        });
      }else setState(() {
        widget.searchbar = true;
      });
    });
    return AppBar(
        title: Text("Bling"),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [ widget.searchbar ? SearchBtn() : Container(width: 0, height: 0),
          SettingsBtn(context)
        ]
    );
  }
}

class  SecondaryAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        color: Colors.blue[500],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(onPressed: (){}, child: Text("FRIENDS", style: TextStyle(color: Colors.white, fontSize: 15.0))),
            TextButton(onPressed: (){}, child: Text("CHATS", style: TextStyle(color: Colors.white, fontSize: 15.0))),
            TextButton(onPressed: (){}, child: Text("PROFILE", style: TextStyle(color: Colors.white, fontSize: 15.0))),
          ],
        )
    );
  }
}

class SettingsAppBar extends AppBar{
  BuildContext context;
  String _title;
  SettingsAppBar(this.context, this._title) : super(
      title: Text(_title),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true
  );
}