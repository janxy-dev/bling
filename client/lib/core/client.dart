import 'dart:convert';

import 'package:bling/core/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/user.dart';
import 'packets/login.dart';
import 'packets/register.dart';

class Client{
   static late IO.Socket socket;
   static late LocalUserModel user;
   static String token = "";
   static String firebaseToken = "";

  static void connect() {
     socket = IO.io("http://10.0.2.2:5000", <String, dynamic>{
       "transports": ["websocket"],
       "autoConnect": false,
     });
     socket.connect();
     socket.onConnect((data) {
       print("Connected to server!");
     });
  }
  static void fetchUser(){
    Client.fetch("fetchLocalUser", onData: (json){
      Client.user = LocalUserModel.fromJson(json);
    });
  }
  static void _auth(response, void onSuccess()?, void onError(List<String> err)?) async{
    if(response["ok"]){
      Client.token = response["token"];
      Storage.prefs.setString("token", Client.token);
      if(onSuccess != null){
        onSuccess();
      }
      return;
    } else{
      if(onError != null){
        onError(response["errors"].cast<String>());
      }
    }
  }
   static void login(LoginPacket login, {void onSuccess()?, void onError(List<String> err)?}){
     socket.emitWithAck("login", login.toJson(), ack: (json){
       _auth(json, onSuccess, onError);
     });
   }
   static void register(RegisterPacket register, {void onSuccess()?, void onError(List<String> err)?}){
    socket.emitWithAck("register", register.toJson(), ack:(json){
      _auth(json, onSuccess, onError);
    });
   }
   static void fetch(String event, {required void onData(json), List<dynamic>? args}){
    if(args == null){
      socket.emitWithAck(event, token, ack: onData);
    }else socket.emitWithAck(event, jsonEncode({"token": token, "args": args}), ack: onData);
   }
   static void createGroup(String groupName){
    socket.emit("createGroup", jsonEncode({"token": Client.token, "groupName": groupName}));
   }
   static void sendMessage(String message, String groupUUID){
    socket.emit("sendMessage", jsonEncode({"token": Client.token, "groupUUID": groupUUID, "message": message}));
   }
   static void joinGroup(String inviteCode){
    socket.emit("joinGroup", jsonEncode({"token": Client.token, "inviteCode": inviteCode}));
   }
   static void logout(){
    token = "";
    Storage.prefs.setString("token", "");
   }
   static Future<NotificationSettings> requestNotificationPermissions() async{
     return Future.value(await FirebaseMessaging.instance.requestPermission(
       alert: true,
       announcement: false,
       badge: true,
       carPlay: false,
       criticalAlert: false,
       provisional: false,
       sound: true,)
     );
   }
   static void initFirebase() async{
     await requestNotificationPermissions();
     firebaseToken = await FirebaseMessaging.instance.getToken(vapidKey: "BD3OQxNYMJE9q7muxrRdpOWlLS-X_jUIKMZYKhTRytwPad2X_Uf0MGTT592U8hM7tT_3Ph5di84BSu9Pcz2mCDY") ?? "";
   }
   static void sendFirebaseToken(){
    socket.emit("firebaseToken", jsonEncode({"token": Client.token, "firebaseToken": Client.firebaseToken}));
   }
}