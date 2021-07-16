import 'package:bling/core/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Client{
   static late LocalUser localUser;
   static late IO.Socket socket;
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
       if(token != null){
         print("TOKEN: " + token);
         Client.token = token;
       } else print("Your username and/or password is incorrect!");
     });
  }
   static void login(String username, String password){
     socket.emit("login", "${username}:${password}");
   }
}