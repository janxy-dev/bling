import 'dart:convert';

import 'message.dart';

class UserModel{
  UserModel();
  String username = "";
  UserModel.fromJson(Map<String, dynamic> json) : username = json['username'];
}

List<MessageModel> _messagesFromJson(json){
  List<MessageModel> msgs = [];
  if(json[0] == null){
    return [MessageModel.fromJson(json)];
  }
  for(int i = 0; i<json.length; i++){
    msgs.add(MessageModel.fromJson(json[i]));
  }
  return msgs;
}

class LocalUserModel {
  LocalUserModel();
  String username = "";
  List<MessageModel> messages = [];
  LocalUserModel.fromJson(Map<String, dynamic> json) :
        username = json['username'],
        messages = json['messages'] != null ? _messagesFromJson(json['messages']) : [];

}