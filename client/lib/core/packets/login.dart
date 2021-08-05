import 'dart:convert';

class LoginPacket{
  final String username;
  final String password;
  LoginPacket(this.username, this.password);

  String toJson() => jsonEncode({
    'username': username,
    'password': password,
  });
}