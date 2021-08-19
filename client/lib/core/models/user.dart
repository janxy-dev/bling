import 'package:bling/config/routes.dart';

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
  List<MessageModel> messages = [];
  LocalUserModel.fromJson(Map<String, dynamic> json) : username = json['username']{
    var msgs = json['messages'];
    for(int i = 0; i<msgs.length; i++){
      MessageModel msg = MessageModel.fromJson(msgs[i]);
      Routes.groups[msg.groupUUID]!.messages.add(msg);
      Storage.addMessage(msg);
   }
  }
}