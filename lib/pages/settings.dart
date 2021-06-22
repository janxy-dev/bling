import 'package:bling/widgets/appbar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SettingsAppBar("Settings")
    );
  }
}