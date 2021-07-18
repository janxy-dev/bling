class LoginModel{
  final String username;
  final String password;
  LoginModel(this.username, this.password);

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}