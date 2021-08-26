import 'package:bling/config/routes.dart';
import 'package:bling/core/client.dart';
import 'package:bling/widgets/loading_animation.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}
class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Routes.isLoading = true;
    Client.connect(() {
      if (Client.token.isNotEmpty) {
        if (Routes.isLoading) {
          Client.fetchGroups((){
            Routes.isLoading = false;
            Navigator.of(context).pushNamed("/");
          });
          return;
        }
        Client.fetchUser();
      }
      else{ //->/->AuthPage
        if(Routes.isLoading){
          Routes.isLoading = false;
          Navigator.of(context).pushNamed("/");
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width/2-15,
            top: MediaQuery.of(context).size.height/2-15,
            child: LoadingAnimation()
          )
        ],
      )
    );
  }
}

