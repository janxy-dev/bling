import 'dart:convert';

class RegisterPacket{
  final String username;
  final String email;
  final String password;
  final String conPassword;
  RegisterPacket(this.username, this.email, this.password, this.conPassword);

  String toJson() => jsonEncode({
    'username': username,
    'email': email,
    'password': password,
    'conPassword': conPassword
  });
}