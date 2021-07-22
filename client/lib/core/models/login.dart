import 'dart:convert';

class LoginModel{
  final String username;
  final String password;
  LoginModel(this.username, this.password);

  String toJson() => jsonEncode({
    'username': username,
    'password': password,
  });
}