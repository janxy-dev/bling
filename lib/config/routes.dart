import 'package:bling/pages/calls.dart';
import 'package:bling/pages/profile.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:flutter/material.dart';
import '../pages/chats.dart';
import '../pages/settings.dart';

class RouteGenerator{

  static final PageController pageCtrl = PageController(initialPage: 1);
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) =>
          Scaffold(
            appBar: PrimaryAppBar(),
            body: Column(
              children: [
                SecondaryAppBar(),
                Expanded(
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: pageCtrl,
                    children: [
                      CallsPage(),
                      ChatsPage(),
                      ProfilePage()
                    ],
                  ),
                )
              ],
            ),
          )

        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return errorRoute;
    }
  }

  static Route<dynamic> getSwipableRoute(Widget page){
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration(seconds: 0),
    );
  }

  static Route<dynamic> errorRoute =
    MaterialPageRoute(builder: (_) => Scaffold(
      body: Text("ERROR"),
    ));
}