import 'package:bling/pages/calls.dart';
import 'package:bling/pages/profile.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:bling/widgets/add_group_button.dart';
import 'package:flutter/material.dart';
import '../pages/chats.dart';
import '../pages/settings.dart';

class Routes{
  static final PageController pageCtrl = PageController(initialPage: 1);
  static int page = 1;

  static ValueNotifier _pageNotifier = ValueNotifier(page);
  static bool _isListenerAdded = false;
  //Custom event for switching pages on half
  static void addPageListener(void func()){
    _pageNotifier.addListener(func);
    //Invoke event inside PageControl event
    if(_isListenerAdded) return;
    pageCtrl.addListener(() {
      int page = 0;
      if(pageCtrl.page! > 1.5) page = 2;
      else if (pageCtrl.page! < 0.5) page = 0;
      else page = 1;
      if(Routes.page != page){
        Routes.page = page;
        _pageNotifier.value = page;
      }
    });
    _isListenerAdded = true;
  }
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) =>
          Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context,
                  bool innerBoxIsScrolled) {
                return [
                  PrimaryAppBar(),
                ];
              },
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
            ),
            floatingActionButton: AddGroupButton(),
          )
        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return _errorRoute;
    }
  }
  static Route<dynamic> _errorRoute =
    MaterialPageRoute(builder: (_) => Scaffold(
      body: Text("ERROR"),
    ));
}