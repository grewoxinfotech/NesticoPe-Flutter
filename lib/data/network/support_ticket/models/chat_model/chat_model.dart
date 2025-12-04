class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderType;
  final String message;
  final DateTime timestamp;
  final String? fileUrl;
  final String? fileName;
  final String? fileType;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.timestamp,
    this.fileUrl,
    this.fileName,
    this.fileType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderType: json['senderType'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      fileType: json['fileType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileType': fileType,
    };
  }

  /// This is remain to do
  bool get isUser {
    const String currentUserId = "CURRENT_USER_ID_HERE"; // Replace this
    return senderId == currentUserId;
  }
}
