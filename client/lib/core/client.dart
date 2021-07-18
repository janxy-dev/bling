import 'dart:convert';
import 'package:bling/core/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/LoginModel.dart';
import 'models/RegisterModel.dart';

class Client{
   static late LocalUser localUser;
   static late IO.Socket socket;
   static String token = "";
   static bool logging = false;
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
    if(!logging){
      logging = true;
      Future.doWhile(() async {
        if(Client.token.isNotEmpty){
          logging = false;
          if(Client.token[0] != '*'){
            if(onSuccess != null) onSuccess();
            Client.token = "";
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
   static void login(LoginModel loginModel, {void onSuccess()?, void onError(List<String> err)?}){
     socket.emit("login", jsonEncode(loginModel.toJson()));
     _auth(onSuccess, onError);
   }
   static void register(RegisterModel registerModel, {void onSuccess()?, void onError(err)?}){
    socket.emit("register", jsonEncode(registerModel.toJson()));
    _auth(onSuccess, onError);
   }
}