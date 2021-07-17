import 'package:bling/pages/auth.dart';
import 'package:bling/pages/auth/login.dart';
import 'package:bling/pages/auth/signup.dart';
import 'package:bling/pages/chat.dart';
import 'package:bling/pages/main/friends.dart';
import 'package:bling/pages/main/chats.dart';
import 'package:bling/pages/main/profile.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:bling/widgets/add_group_button.dart';
import 'package:flutter/material.dart';
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
        if(settings.arguments == null) return MaterialPageRoute(builder: (_) => AuthPage());
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            body:
            Column(
              children: [
                //Status bar
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).padding.top,
                  color: Theme.of(context).primaryColor,
                ),

                Expanded(
                  child: NestedScrollView(
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
                      )
                  ),
                ),
              ],
            ),

            floatingActionButton: AddGroupButton(),
          );
        }
        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/chat':
        return MaterialPageRoute(builder: (_) => Chat(settings.arguments as String));
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage());
      default:
        return _errorRoute;
    }
  }
  static Route<dynamic> _errorRoute =
    MaterialPageRoute(builder: (_) => Scaffold(
      body: SafeArea(child: Text("ERROR")),
    ));
}