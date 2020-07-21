import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {

  int chatId;
    int to;
    int from;
    String message;
    String chatType;
    bool toUserOnlineStatus;
    bool isFromMe;
    
    ChatMessage({
        this.chatId,
        this.to,
        this.from,
        this.message,
        this.chatType,
        this.toUserOnlineStatus, 
        this.isFromMe,
    });

    

    factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        chatId: json["chat_id"],
        to: json["to"],
        from: json["from"],
        message: json["message"],
        chatType: json["chat_type"],
        toUserOnlineStatus: json["to_user_online_status"],
    );

    Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "to": to,
        "from": from,
        "message": message,
        "chat_type": chatType,
        "to_user_online_status": toUserOnlineStatus,
    };
}
