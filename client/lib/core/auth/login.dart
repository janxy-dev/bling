import 'package:bling/core/client.dart';
String login(String username, String password){
  Client.socket.emit("login", "${username}:${password}");
  Client.socket.on("login", (auth){
    if(auth){
      print("You have successfully logged in!");
    } else print("Your username and/or password is incorrect!");
  });
  return "";
}