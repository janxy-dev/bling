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
}