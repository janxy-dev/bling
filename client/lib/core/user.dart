class User{
  String username;
  User(this.username);
}
class LocalUser extends User{
  String token;
  String email;
  LocalUser(this.token, String username, this.email) : super(username);
}