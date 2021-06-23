import 'package:bling/widgets/app_bars.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SettingsAppBar("Settings")
          ],
        ),
    );
  }
}