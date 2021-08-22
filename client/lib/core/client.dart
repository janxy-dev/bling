import 'dart:convert';

import 'package:bling/config/routes.dart';
import 'package:bling/core/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/group.dart';
import 'models/message.dart';
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
   static bool isLogging = false;

  static void connect(Function onConnect) {
     socket = IO.io("http://10.0.2.2:5000", {
       "transports": ["websocket"],
       "reconnection": true,
       "reconnectionDelay": 200,
       "reconnectionAttempts": double.infinity
     });
     socket.onConnect((data) {
       print("Connected to server!");
       isConnected = true;
       onConnect();
     });
  }
  static void fetchUser() {
     Client.fetch("fetchLocalUser", onData: (json){
      user = LocalUserModel.fromJson(json);
      //add undelivered messages
      var msgs = json['messages'];
      for(int i = 0; i<msgs.length; i++){
        MessageModel msg = MessageModel.fromJson(msgs[i]);
        GroupModel group = Routes.groups[msg.groupUUID]!;
        if(group.messages.indexWhere((e) => e.uuid == msg.uuid) != -1) return;
        group.messages.add(msg);
        //change order
        Routes.groups.remove(msg.groupUUID);
        Routes.groups.putIfAbsent(group.groupUUID, () => group);
        Storage.addMessage(msg);
      }
      sendFirebaseToken();
      onUserFetch();
    });
  }
  //sorting groups by last message timestamp
   static void _sortGroups(){
    if(Routes.groups.length < 2) return;
    var groups = Routes.groups.values.toList();
    for(int i = 0; i<groups.length; i++){
      for(int n = 0; n<groups.length-1; n++){
        if(groups[n].messages.isEmpty) continue;
        if(groups[n+1].messages.isEmpty || groups[n].messages.last.time.millisecondsSinceEpoch > groups[n+1].messages.last.time.millisecondsSinceEpoch){
          GroupModel temp = groups[n];
          groups[n] = groups[n+1];
          groups[n+1] = temp;
        }
      }
    }
    Routes.groups.clear();
    for(int i = 0; i<groups.length; i++){
      Routes.groups.putIfAbsent(groups[i].groupUUID, () => groups[i]);
    }
   }
   static void fetchGroups(Function then){
     Client.fetch("fetchAllGroups", onData: (json) {
       if(json != ""){
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
         //add local messages to groups
         for(int i = 0; i<Routes.groups.keys.length; i++){
           String groupUUID = Routes.groups.keys.elementAt(i);
           Storage.getMessagesCount(groupUUID).then((msgCount) {
             Storage.getMessages(groupUUID, msgCount, 15).then((value) {
               Routes.groups[groupUUID]!.messages.addAll(value);
               if(i == Routes.groups.keys.length-1) {
                 _sortGroups();
                 then();
               }
             });
           });
         }
       } else then();
     });
   }
  static void _auth(response, void onSuccess()?, void onError(List<String> err)?) async{
    if(response["ok"]){
      Client.token = response["token"];
      Storage.prefs.setString("token", Client.token);
        if(onSuccess != null){
          fetchGroups((){
           onSuccess();
           isLogging = false;
         });
        }
      return;
    } else{
      if(onError != null){
        onError(response["errors"].cast<String>());
        isLogging = false;
      }
    }
  }
   static void loginTimeout(void onSuccess()?, void onError(List<String> err)?){
     if(isLogging) return;
     isLogging = true;
     Future.delayed(Duration(seconds: 15), (){
       if(isLogging){
         onSuccess = (){};
         if(onError != null){
           onError(["Login timeout"]);
         }
         isLogging = false;
       }
     });
   }
   static void login(LoginPacket login, {void onSuccess()?, void onError(List<String> err)?}){
     loginTimeout(onSuccess, onError);
     socket.emitWithAck("login", login.toJson(), ack: (json){
       _auth(json, onSuccess, onError);
     });
   }
   static void register(RegisterPacket register, {void onSuccess()?, void onError(List<String> err)?}){
    loginTimeout(onSuccess, onError);
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