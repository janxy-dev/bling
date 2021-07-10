import 'package:bling/core/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Client{
   static late LocalUser localUser;
   static late IO.Socket socket;
   static void login(String token){
     localUser = LocalUser(token, "asd", "asd");
  }
  static void connect(){
     socket = IO.io("http://10.0.2.2:5000", <String, dynamic>{
       "transports": ["websocket"],
       "autoConnect": false,
     });
     socket.connect();
     socket.onConnect((data) {
       print("Connected to server!");
     });
  }
}