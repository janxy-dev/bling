import '../storage.dart';
import 'message.dart';

class UserModel{
  UserModel();
  String username = "";
  UserModel.fromJson(Map<String, dynamic> json) : username = json['username'];
}

class LocalUserModel {
  LocalUserModel();
  String username = "";
  LocalUserModel.fromJson(Map<String, dynamic> json) : username = json['username']{
    var msgs = json['messages'];
    for(int i = 0; i<msgs.length; i++){
      Storage.addMessage(MessageModel.fromJson(msgs[i]));
   }
  }
}