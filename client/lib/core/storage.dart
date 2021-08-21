import 'package:bling/core/models/group.dart';
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
    await database.execute("CREATE TABLE IF NOT EXISTS messages (id INTEGER, message TEXT, sender VARCHAR(15), group_uuid CHAR(36), uuid CHAR(36) UNIQUE, seen INTEGER, time INTEGER);");
    isLoaded = true;
  }
  static Future<List<MessageModel>> getMessages(String groupUUID, int fromMessageID, int count) async{
    List<Map> query = await database.rawQuery("SELECT * FROM messages WHERE group_uuid = '$groupUUID' AND id <= $fromMessageID AND id > ${fromMessageID-count}");
    return Future.value(query.map((e) => MessageModel(e["message"], e["sender"], e["group_uuid"], e["uuid"], e["id"], e["seen"] == 0 ? false : true, DateTime.fromMillisecondsSinceEpoch(e["time"]))).toList());
  }
  static void addMessage(MessageModel msg) async{
    int messages = await getMessagesCount(msg.groupUUID);
    await database.insert("messages", {"message": msg.message, "sender": msg.sender, "group_uuid": msg.groupUUID, "uuid": msg.uuid, "id": messages+1, "seen": msg.seen ? 1 : 0, "time": msg.time.millisecondsSinceEpoch}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }
  static void seenMessages(GroupModel group) async{
    await database.execute("UPDATE messages SET seen = 1 WHERE group_uuid = '${group.groupUUID}'");
  }
  static Future<int> getMessagesCount(String groupUUID) async{
    return Future.value(Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT(*) FROM messages WHERE group_uuid = '$groupUUID'")) ?? 0);
  }
}