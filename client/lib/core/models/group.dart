import 'dart:convert';
class GroupModel{
  String? groupUUID;
  String name="";
  GroupModel({this.groupUUID});
  GroupModel.fromJson(Map<String, dynamic> json) : name = json['name'], groupUUID = json['groupUUID'];
  String toJson() => jsonEncode({
    'name': name,
  });
}