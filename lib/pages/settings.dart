import 'package:bling/widgets/app_bars.dart';
import 'package:bling/widgets/settings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (a,b) => [SettingsAppBar("Settings")],
          body: Column(
            children: [
              ToggleSetting(title: "Dark Theme", onToggled: (bool value){
                print(value);
              }),
              ],
            )
        )
    );
  }
}


