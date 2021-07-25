import 'dart:convert';
class GroupModel{
  List<dynamic> admins;
  String? groupUUID;
  String name="";
  GroupModel(this.admins, {this.groupUUID});
  GroupModel.fromJson(Map<String, dynamic> json) : name = json['name'], groupUUID = json['groupUUID'], admins = json['admins'].values.toList();
  String toJson() => jsonEncode({
    'name': name,
    'admins': admins
  });
}