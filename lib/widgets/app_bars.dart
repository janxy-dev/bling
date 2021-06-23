import 'package:bling/config/routes.dart';
import 'package:flutter/material.dart';

Widget SearchBtn(){
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Icon(Icons.search),
    ),
  );
}

Widget SettingsBtn(BuildContext context){
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
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
    behavior: HitTestBehavior.opaque,
    onTap: (){
      Routes.pageCtrl.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.ease);
    },
    child: Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Text(
          name, style: TextStyle(color: Colors.grey, fontSize: 15.0, decoration: TextDecoration.none)
      ),
    ),
  );
}

class PrimaryAppBar extends StatefulWidget {
  @override
  _PrimaryAppBarState createState() => _PrimaryAppBarState();
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  bool _listenerAdded = false;
  @override
  Widget build(BuildContext context) {

    if(!_listenerAdded){
      Routes.addPageListener(() {
        //update widget on page switch
        setState(() {});
      });
      _listenerAdded = true;
    }
    return SliverAppBar(
        pinned: true,
        title: Text("Bling"),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [ Routes.page != 2 ? SearchBtn() : Container(width: 0, height: 0),
          SettingsBtn(context)
        ]
    );
  }
}

class  SecondaryAppBar extends StatefulWidget {
  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {

  bool _listenerAdded = false;
  double _margin = 0.0;

  @override
  Widget build(BuildContext context) {
    if(!_listenerAdded){
      Routes.pageCtrl.addListener(() {
        setState(() {
          var multiplier = Routes.pageCtrl.page!.toDouble()-1.0;
          _margin = (MediaQuery.of(context).size.width/3-2.0)*multiplier;
        },);
      });
      _listenerAdded = true;
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
                transform: Matrix4.translationValues(_margin, 0.0, 0.0),
                width: 60.0,
                height: 5.0,
                color: Colors.grey[300],
              ),
          ]
        )
    );
  }
}

class SettingsAppBar extends StatelessWidget{
  final String title;
  SettingsAppBar(this.title);
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: new IconButton(
        icon: new Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
