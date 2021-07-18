class RegisterModel{
  final String username;
  final String email;
  final String password;
  final String conPassword;
  RegisterModel(this.username, this.email, this.password, this.conPassword);

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'conPassword': conPassword
  };
}