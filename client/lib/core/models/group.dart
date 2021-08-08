import 'dart:convert';

import 'message.dart';
class GroupModel{
  String groupUUID;
  String name;
  List<MessageModel> messages = [];
  GroupModel(this.groupUUID, this.name);
  GroupModel.fromJson(Map<String, dynamic> json) : name = json['name'], groupUUID = json['groupUUID'];
  String toJson() => jsonEncode({
    'name': name,
  });
}