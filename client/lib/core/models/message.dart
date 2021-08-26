import 'package:intl/intl.dart';

class MessageModel{
  String message;
  String sender;
  String groupUUID;
  String uuid;
  int id = 0;
  bool seen = false;
  DateTime time;
  MessageModel(this.message, this.sender, this.groupUUID, this.uuid, this.id, this.seen, this.time);
  MessageModel.fromJson(Map<String, dynamic> json) :
        message = json['message'],
        sender = json['sender'],
        groupUUID = json['groupUUID'],
        uuid = json['uuid'],
        time = DateTime.now();
  String getFormattedDate(){
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));
    DateTime weekAgo = now.subtract(Duration(days: 7));
    String hm = DateFormat.Hm(Intl.defaultLocale).format(time);
    if(time.day == now.day && time.month == now.month && time.year == now.year) {
      return hm;
    }
    else if(time.day == yesterday.day && time.month == yesterday.month && time.year == yesterday.year){
      return "Yesterday";
    }
    else if(time.isAfter(weekAgo) && !(time.day == weekAgo.day && time.month == weekAgo.month && time.year == weekAgo.year)){
      return DateFormat.EEEE(Intl.defaultLocale).format(time);
    }
    else return DateFormat.yMd(Intl.defaultLocale).format(time);
  }
  String getFormattedTime(){
    return DateFormat.Hm(Intl.defaultLocale).format(time);
  }
}