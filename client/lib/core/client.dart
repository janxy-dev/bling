import 'dart:convert';
import 'dart:io';

import 'package:bling/config/routes.dart';
import 'package:bling/core/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/group.dart';
import 'models/user.dart';
import 'packets/login.dart';
import 'packets/register.dart';

class Client{
   static late IO.Socket socket;
   static LocalUserModel user = LocalUserModel();
   static String token = "";
   static String firebaseToken = "";
   static bool isConnected = false;
   static Function onUserFetch = (){};

  static void connect(Function onConnect) {
     socket = IO.io("http://10.0.2.2:5000", IO.OptionBuilder()
     .setTransports(['websocket']).build());
     socket.onConnect((data) {
       print("Connected to server!");
       isConnected = true;
       onConnect();
     });
     socket.onDisconnect((data) => socket.connect());
     socket.onConnectError((data) {
       Future.delayed(Duration(milliseconds: 500), (){
         socket.connect();
       });
     });
  }
  static void fetchUser() {
     Client.fetch("fetchLocalUser", onData: (json){
      user = LocalUserModel.fromJson(json);
      sendFirebaseToken();
      onUserFetch();
    });
  }
   static void fetchGroups(Function then){
     Client.fetch("fetchAllGroups", onData: (json) {
       if(json != null){
         //Group isn't sent in a list if there is only 1 group
         if(json[0] == null){
           GroupModel model = GroupModel.fromJson(json);
           Routes.groups.putIfAbsent(model.groupUUID, () => model);
         }
         else{
           for(int i = 0; i<json.length; i++){
             GroupModel model = GroupModel.fromJson(json[i]);
             Routes.groups.putIfAbsent(model.groupUUID, () => model);
           }
         }
         //add messages to groups
         for(int i = 0; i<Routes.groups.keys.length; i++){
           String groupUUID = Routes.groups.keys.elementAt(i);
           Storage.getMessagesCount(groupUUID).then((msgCount) {
             Storage.getMessages(groupUUID, msgCount, 15).then((value) {
               Routes.groups[groupUUID]!.messages.addAll(value);
               if(i == Routes.groups.keys.length-1) then();
             });
           });
         }
       }
     });
   }
  static void _auth(response, void onSuccess()?, void onError(List<String> err)?) async{
    if(response["ok"]){
      Client.token = response["token"];
      Storage.prefs.setString("token", Client.token);
        if(onSuccess != null){
          fetchGroups((){
           onSuccess();
         });
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