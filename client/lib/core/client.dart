import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/user.dart';
import 'packets/login.dart';
import 'packets/register.dart';

class Client{
   static late IO.Socket socket;
   static late LocalUserModel user;
   static String token = "";
   static bool isAuthenticating = false;
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
  static void _auth(void onSuccess()?, void onError(List<String> err)?){
    if(!isAuthenticating){
      isAuthenticating = true;
      Future.doWhile(() async {
        if(Client.token.isNotEmpty){
          isAuthenticating = false;
          if(Client.token[0] != '*'){
            Client.fetch("fetchLocalUser", onData: (json){
              Client.user = LocalUserModel.fromJson(json);
              if(onSuccess != null) onSuccess();
            });
            return false;
          }
          String err = Client.token.substring(1);
          List<String> errors = err.split("\n");
          errors.removeLast();
          if(onError != null) onError(errors);
          Client.token = "";
          return false;
        }
        await Future.delayed(Duration(milliseconds: 20));
        return true;
      });
    }
  }
   static void login(LoginPacket login, {void onSuccess()?, void onError(List<String> err)?}){
     socket.emit("login", login.toJson());
     _auth(onSuccess, onError);
   }
   static void register(RegisterPacket register, {void onSuccess()?, void onError(err)?}){
    socket.emit("register", register.toJson());
    _auth(onSuccess, onError);
   }
   static void fetch(String event, {required void onData(json), List<dynamic>? args}){
    if(args == null){
      socket.emit(event, token);
    }else socket.emit(event, jsonEncode({"token": token, "args": args}));
     socket.once(event, (data){
       onData(data);
     });
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