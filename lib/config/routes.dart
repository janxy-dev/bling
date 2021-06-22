import 'package:bling/pages/calls.dart';
import 'package:bling/pages/profile.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:bling/widgets/join_button.dart';
import 'package:flutter/material.dart';
import '../pages/chats.dart';
import '../pages/settings.dart';

class Routes{

  static final PageController pageCtrl = PageController(initialPage: 1);
  static int page = 1;
  static final List<Function()> pageListeners = [];
  static bool pageCtrlListener = false;

  //Custom event for switching pages on half
  static void addPageListener(void func()){
    //Invoke event inside PageControl event
    if(!pageCtrlListener){
      pageCtrl.addListener(() {
        int page = 0;
        if(pageCtrl.page! > 1.5) page = 2;
        else if (pageCtrl.page! < 0.5) page = 0;
        else page = 1;
        if(Routes.page != page){
          Routes.page = page;
          for(int i = 0; i<pageListeners.length; i++){
            pageListeners[i]();
          }
        }
      });
    }
    pageListeners.add(func);
  }
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
            floatingActionButton: JoinButton(),
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