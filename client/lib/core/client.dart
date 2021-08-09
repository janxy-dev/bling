import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/user.dart';
import 'packets/login.dart';
import 'packets/register.dart';

class Client{
   static late IO.Socket socket;
   static late LocalUserModel user;
   static String token = "";
  static void connect(){
     socket = IO.io("http://10.0.2.2:5000", <String, dynamic>{
       "transports": ["websocket"],
       "autoConnect": false,
     });
     socket.connect();
     socket.onConnect((data) {
       print("Connected to server!");
     });
     socket.on("login", (token){
       Client.token = token;
     });
  }
  static void _auth(response, void onSuccess()?, void onError(List<String> err)?){
    if(response["ok"]){
      Client.token = response["token"];
      if(onSuccess != null){
        Client.fetch("fetchLocalUser", onData: (json){
          Client.user = LocalUserModel.fromJson(json);
        });
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
}