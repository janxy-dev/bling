class MessageModel{
  String message;
  String sender;
  bool isClients;
  MessageModel(this.message, this.sender, this.isClients);
  MessageModel.fromJson(Map<String, dynamic> json) :
        message = json['message'],
        sender = json['sender'],
        isClients = false;
}