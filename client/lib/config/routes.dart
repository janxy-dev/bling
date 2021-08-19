import 'package:bling/core/client.dart';
import 'package:bling/core/models/group.dart';
import 'package:bling/pages/auth.dart';
import 'package:bling/pages/auth/login.dart';
import 'package:bling/pages/auth/signup.dart';
import 'package:bling/pages/chat.dart';
import 'package:bling/pages/loading.dart';
import 'package:bling/pages/main.dart';
import 'package:flutter/material.dart';
import '../pages/settings.dart';

class Routes{
  static late PageController pageCtrl;
  static late int page;
  static late ValueNotifier _pageNotifier;
  static late bool _isListenerAdded;
  static late Map<String, GroupModel> groups;
  static late RouteSettings settings;
  static late bool isLoading;
  static void init(){
    pageCtrl = PageController(initialPage: 1);
    page = 1;
    _pageNotifier = ValueNotifier(page);
    _isListenerAdded = false;
    groups = {};
  }
  static GroupModel getGroup(String groupUUID){
    return groups[groupUUID]!;
  }
  //Custom event for switching pages on half (change later)
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Routes.settings = settings;
    switch(settings.name){
      case '/':
        if(!Client.isConnected) return MaterialPageRoute(builder: (_) => LoadingPage());
        if(Client.token.isEmpty) return MaterialPageRoute(builder: (_) => AuthPage());
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/chat':
        return MaterialPageRoute(builder: (_) => Chat(settings.arguments as ChatArguments));
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