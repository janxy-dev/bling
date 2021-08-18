import 'package:bling/core/models/message.dart';
import 'package:bling/pages/main/chats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'config/routes.dart';

class LocalNotifications{
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static List<Function> listeners = [];
  static void init(BuildContext context) async{
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async{});
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async{
          if(payload != null){
            for(int i = listeners.length-1; i>=0; i--){
              listeners[i](payload);
            }
          }
        });
  }

  static void showMessageNotification(String groupName, String groupUUID, String sender, String message) async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        '0', 'message', 'message notification',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, groupName, sender + ": " + message, platformChannelSpecifics,
        payload: groupUUID);
  }
}