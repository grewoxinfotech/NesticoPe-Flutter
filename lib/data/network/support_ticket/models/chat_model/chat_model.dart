// class ChatMessage {
//   final String? id;
//   final String senderId;
//   final String? senderName;
//   final String? senderType;
//   final String message;
//   final DateTime? timestamp;
//   final String? fileUrl;
//   final String? fileName;
//   final String? fileType;
//
//   ChatMessage({
//     this.id,
//     required this.senderId,
//     this.senderName,
//     this.senderType,
//     required this.message,
//     this.timestamp,
//     this.fileUrl,
//     this.fileName,
//     this.fileType,
//   });
//
//   factory ChatMessage.fromJson(Map<String, dynamic> json) {
//     return ChatMessage(
//       id: json['id'] ?? '',
//       senderId: json['senderId'] ?? '',
//       senderName: json['senderName'] ?? '',
//       senderType: json['senderType'] ?? '',
//       message: json['message'] ?? '',
//       timestamp: DateTime.parse(json['timestamp']),
//       fileUrl: json['fileUrl'],
//       fileName: json['fileName'],
//       fileType: json['fileType'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'senderId': senderId,
//       'senderName': senderName,
//       'senderType': senderType,
//       'message': message,
//       'timestamp': DateTime.now().toIso8601String(),
//       'fileUrl': fileUrl,
//       'fileName': fileName,
//       'fileType': fileType,
//     };
//   }
//
//   /// This is remain to do
//   bool get isUser {
//     const String currentUserId = "CURRENT_USER_ID_HERE"; // Replace this
//     return senderId == currentUserId;
//   }
// }

class ChatMessage {
  final String id;
  final String senderId;
  final String? receiverId;
  final String message;
  final String type;
  final String? fileUrl;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? senderFirstName;
  final String? senderLastName;
  final String? senderUsername;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.receiverId,
    required this.message,
    required this.type,
    this.fileUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.senderFirstName,
    this.senderLastName,
    this.senderUsername,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'];

    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'],
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      fileUrl: json['fileUrl'],
      status: json['status'] ?? 'sent',

      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),

      senderFirstName: sender?['firstName'],
      senderLastName: sender?['lastName'],
      senderUsername: sender?['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "type": type,
      "fileUrl": fileUrl,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "sender": {
        "firstName": senderFirstName,
        "lastName": senderLastName,
        "username": senderUsername,
      },
    };
  }

  /// This is remain to do
  // bool get isUser {
  //   const String currentUserId = "CURRENT_USER_ID_HERE"; // Replace this
  //   return senderId == currentUserId;
  // }
}

class SendChatMessage {
  final String message;
  final String ticketId;

  SendChatMessage({required this.message, required this.ticketId});

  Map<String, dynamic> toJson() {
    return {'ticketId': ticketId, 'message': message};
  }
}
