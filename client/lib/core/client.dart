import 'package:bling/core/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
   static void login(String username, String password, {void onSuccess()?, void onError(List<String> err)?}){
     socket.emit("login", "$username:$password");
     _auth(onSuccess, onError);
   }
   static void register(String username, String email, String password, String conPassword, {void onSuccess()?, void onError(err)?}){
    socket.emit("register", "$username:$email:$password:$conPassword");
    _auth(onSuccess, onError);
   }
}