import 'dart:convert';

class RegisterModel{
  final String username;
  final String email;
  final String password;
  final String conPassword;
  RegisterModel(this.username, this.email, this.password, this.conPassword);

  String toJson() => jsonEncode({
    'username': username,
    'email': email,
    'password': password,
    'conPassword': conPassword
  });
}