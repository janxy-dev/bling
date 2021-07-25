import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/group.dart';
import 'models/login.dart';
import 'models/register.dart';

class Client{
   static late IO.Socket socket;
   static String token = "";
   static bool isAuthenticating = false;
   static bool isFetching = false;
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
   static void login(LoginModel loginModel, {void onSuccess()?, void onError(List<String> err)?}){
     socket.emit("login", loginModel.toJson());
     _auth(onSuccess, onError);
   }
   static void register(RegisterModel registerModel, {void onSuccess()?, void onError(err)?}){
    socket.emit("register", registerModel.toJson());
    _auth(onSuccess, onError);
   }
   static void fetch(String event, void onData(json)){
    if(isFetching) return null;
    socket.emit(event, token);
    socket.on(event, (data){
      onData(data);
    });
   }
   static void createGroup(String groupName){
    GroupModel group = GroupModel(<String>[Client.token]);
    group.name = groupName;
    socket.emit("createGroup", group);
   }
}