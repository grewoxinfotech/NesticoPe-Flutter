class TicketResponseModel {
  final bool? success;
  final String? message;
  final TicketData? data;

  TicketResponseModel({this.success, this.message, this.data});

  factory TicketResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? TicketData.fromJson(json['data']) : null,
    );
  }
}

// ========================= DATA (Pagination + Items) =========================

class TicketData {
  final List<TicketItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  TicketData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      items:
          json['items'] != null
              ? List<TicketItem>.from(
                json['items'].map((x) => TicketItem.fromJson(x)),
              )
              : [],
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      fetchedAll: json['fetchedAll'],
    );
  }
}

// ========================= TICKET ITEM =========================

class TicketItem {
  final String? id;
  final String? createdById;
  final String? updatedBy;
  final String? relatedId;
  final String? title;
  final String? category;
  final String? ticketType;
  final String? description;
  final String? status;
  final String? priority;
  final String? resolutionNotes;
  final List<dynamic>? files;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CreatedBy? createdBy;
  // final List<TicketMessage>? messages;

  TicketItem({
    this.id,
    this.createdById,
    this.updatedBy,
    this.relatedId,
    this.title,
    this.category,
    this.ticketType,
    this.description,
    this.status,
    this.priority,
    this.resolutionNotes,
    this.files,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    // this.messages,
  });

  factory TicketItem.fromJson(Map<String, dynamic> json) {
    return TicketItem(
      id: json['id'],
      createdById: json['created_by'],
      updatedBy: json['updated_by'],
      relatedId: json['relatedId'],
      title: json['title'],
      category: json['category'],
      ticketType: json['ticketType'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      resolutionNotes: json['resolution_notes'],
      files: json['files'] ?? [],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdBy:
          json['createdBy'] != null
              ? CreatedBy.fromJson(json['createdBy'])
              : null,
      // messages: json['messages'] != null
      //     ? List<TicketMessage>.from(
      //   json['messages'].map((x) => TicketMessage.fromJson(x)),
      // )
      //     : [],
    );
  }
}

// ========================= MESSAGE MODEL =========================

// class TicketMessage {
//   final String? id;
//   final String? senderId;
//   final String? senderName;
//   final String? senderType;
//   final String? message;
//   final String? fileUrl;
//   final String? fileName;
//   final String? fileType;
//   final DateTime? timestamp;
//
//   TicketMessage({
//     this.id,
//     this.senderId,
//     this.senderName,
//     this.senderType,
//     this.message,
//     this.fileUrl,
//     this.fileName,
//     this.fileType,
//     this.timestamp,
//   });
//
//   factory TicketMessage.fromJson(Map<String, dynamic> json) {
//     return TicketMessage(
//       id: json['id'],
//       senderId: json['senderId'],
//       senderName: json['senderName'],
//       senderType: json['senderType'],
//       message: json['message'],
//       fileUrl: json['fileUrl'],
//       fileName: json['fileName'],
//       fileType: json['fileType'],
//       timestamp:
//           json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
//     );
//   }
// }

// ========================= CREATED BY MODEL =========================

class CreatedBy {
  final String? id;
  final String? username;
  final String? userType;

  CreatedBy({this.id, this.username, this.userType});

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'],
      username: json['username'],
      userType: json['userType'],
    );
  }
}

/// Create ticket model
class TicketCreateRequest {
  final String title;
  final String description;
  final String category;
  final String ticketType;
  final String priority;

  TicketCreateRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.ticketType,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "category": category,
    "ticketType": ticketType,
    "priority": priority,
  };
}
