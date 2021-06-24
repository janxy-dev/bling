import 'package:bling/config/routes.dart';
import 'package:flutter/material.dart';

Widget searchBtn(){
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Icon(Icons.search),
    ),
  );
}

Widget settingsBtn(BuildContext context){
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

Widget navbarBtn(BuildContext context, String name, int page){
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

  @override
  void initState(){
    super.initState();
    Routes.addPageListener(() {
      //update widget on page switch
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        primary: false,
        title: Text("Bling"),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [ Routes.page != 2 ? searchBtn() : Container(width: 0, height: 0),
          settingsBtn(context)
        ]
    );
  }
}

class  SecondaryAppBar extends StatefulWidget {
  SecondaryAppBar();
  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {

  double _margin = 0.0;

  @override
  void initState(){
    super.initState();
    Routes.pageCtrl.addListener(() {
      if(this.mounted){
        setState(() {
          var multiplier = Routes.pageCtrl.page!.toDouble()-1.0;
          _margin = (MediaQuery.of(context).size.width/3-2.0)*multiplier;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navbarBtn(context, "FRIENDS", 0),
            navbarBtn(context, "CHATS", 1),
            navbarBtn(context, "PROFILE", 2),
          ],
        ),
          Container(
            transform: Matrix4.translationValues(_margin, 0.0, 0.0),
            width: 60.0,
            height: 5.0,
            color: Colors.grey[300],
          ),
      ]
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
