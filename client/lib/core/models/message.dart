class MessageModel{
  String message;
  String sender;
  String groupUUID;
  String uuid;
  int id = 0;
  MessageModel(this.message, this.sender, this.groupUUID, this.uuid, this.id);
  MessageModel.fromJson(Map<String, dynamic> json) :
        message = json['message'],
        sender = json['sender'],
        groupUUID = json['groupUUID'],
        uuid = json['uuid'];
}