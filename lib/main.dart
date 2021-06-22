import 'package:flutter/material.dart';
import 'config/routes.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    onGenerateRoute: Routes.generateRoute,
  ));
}



