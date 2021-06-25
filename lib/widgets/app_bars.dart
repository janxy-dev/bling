import 'package:bling/config/routes.dart';
import 'package:flutter/material.dart';

class PrimaryAppBar extends StatefulWidget {
  @override
  _PrimaryAppBarState createState() => _PrimaryAppBarState();
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {

  Widget _searchBtn(){
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: (){},
    );
  }

  Widget _settingsBtn(){
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: ()=>Navigator.of(context).pushNamed("/settings"),
    );
  }

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
        actions: [ Routes.page != 2 ? _searchBtn() : Container(width: 0, height: 0),
          _settingsBtn()
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

  Widget _navbarBtn(BuildContext context, String name, int page){
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
            _navbarBtn(context, "FRIENDS", 0),
            _navbarBtn(context, "CHATS", 1),
            _navbarBtn(context, "PROFILE", 2),
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
    return AppBar(
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
