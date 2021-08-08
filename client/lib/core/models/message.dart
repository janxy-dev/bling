class MessageModel{
  String message;
  String sender;
  String groupUUID;
  MessageModel(this.message, this.sender, this.groupUUID);
  MessageModel.fromJson(Map<String, dynamic> json) :
        message = json['message'],
        sender = json['sender'],
        groupUUID = json['groupUUID'];
}