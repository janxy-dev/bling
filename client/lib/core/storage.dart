import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'models/message.dart';
class Storage{
  static bool isLoaded = false;
  static late SharedPreferences prefs;
  static late Database database;
  static Future<void> load() async{
    prefs = await SharedPreferences.getInstance();
    database = await openDatabase("database.db");
    await database.execute("CREATE TABLE IF NOT EXISTS messages (message TEXT, sender VARCHAR(15), group_uuid CHAR(36));");
    isLoaded = true;
  }
  static Future<List<MessageModel>> getMessages(String groupUUID) async{
    List<Map> query = await database.rawQuery("SELECT * FROM messages WHERE group_uuid = '${groupUUID}'");
    return Future.value(query.map((e) => MessageModel(e["message"], e["sender"], e["group_uuid"])).toList());
  }
  static void addMessage(MessageModel msg){
    database.rawQuery("SELECT * FROM messages").then((value) => print(value));
    database.insert("messages", {"message": msg.message, "sender": msg.sender, "group_uuid": msg.groupUUID});
  }
}