import 'package:bling/config/routes.dart';
import 'package:bling/core/models/group.dart';

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
  LocalUserModel.fromJson(Map<String, dynamic> json) : username = json['username'];
}