import 'package:bling/config/themes.dart';
import 'package:bling/core/client.dart';
import 'package:bling/widgets/app_bars.dart';
import 'package:bling/widgets/restart.dart';
import 'package:bling/widgets/setting.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
              SettingsAppBar("Settings"),
              Expanded(
                child: ListView(
                  children: [
                    ToggleSetting(title: "Dark Theme", onToggled: (bool value){
                      Themes.themes.toggleTheme();
                    }),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-40, right: MediaQuery.of(context).size.width/2-40),
                      child: TextButton(onPressed: (){
                        Client.logout();
                        RestartWidget.restartApp(context);
                        Navigator.of(context).pushNamed("/");
                      }, child: Text("Log out")),
                    ),
                  ],
                ),
              )
              ],
            )
    );
  }
}


