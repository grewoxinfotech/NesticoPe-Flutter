import 'dart:convert';

class NotificationModel {
  bool? success;
  String? message;
  NotificationMessage? data;

  NotificationModel({this.success, this.message, this.data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? NotificationMessage.fromJson(json['data'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class NotificationMessage {
  List<NotificationItem>? notifications;
  Pagination? pagination;

  NotificationMessage({this.notifications, this.pagination});

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      notifications:
          (json['notifications'] as List?)
              ?.map((e) => NotificationItem.fromJson(e))
              .toList(),
      pagination:
          json['pagination'] != null
              ? Pagination.fromJson(json['pagination'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'notifications': notifications?.map((e) => e.toJson()).toList(),
    'pagination': pagination?.toJson(),
  };
}

class NotificationItem {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? userId;
  String? title;
  String? message;
  String? type;
  String? priority;
  String? status;
  String? relatedId;
  String? relatedType;
  String? actionUrl;
  NotificationMetadata? metadata;
  DateTime? scheduledFor;
  DateTime? expiresAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  NotificationItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.userId,
    this.title,
    this.message,
    this.type,
    this.priority,
    this.status,
    this.relatedId,
    this.relatedType,
    this.actionUrl,
    this.metadata,
    this.scheduledFor,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    NotificationMetadata? parsedMetadata;

    if (json['metadata'] != null && json['metadata'] is String) {
      try {
        final decoded = jsonDecode(json['metadata']);
        parsedMetadata = NotificationMetadata.fromJson(decoded);
      } catch (_) {}
    }

    return NotificationItem(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      priority: json['priority'],
      status: json['status'],
      relatedId: json['related_id'],
      relatedType: json['related_type'],
      actionUrl: json['action_url'],
      metadata: parsedMetadata,
      scheduledFor: _parseDate(json['scheduled_for']),
      expiresAt: _parseDate(json['expires_at']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }
  NotificationItem copyWith({
    String? status,
    NotificationMetadata? metadata,
    DateTime? updatedAt,
  }) {
    return NotificationItem(
      id: id,
      createdBy: createdBy,
      updatedBy: updatedBy,
      userId: userId,
      title: title,
      message: message,
      type: type,
      priority: priority,
      status: status ?? this.status,
      relatedId: relatedId,
      relatedType: relatedType,
      actionUrl: actionUrl,
      metadata: metadata ?? this.metadata,
      scheduledFor: scheduledFor,
      expiresAt: expiresAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'user_id': userId,
    'title': title,
    'message': message,
    'type': type,
    'priority': priority,
    'status': status,
    'related_id': relatedId,
    'related_type': relatedType,
    'action_url': actionUrl,
    'metadata': metadata != null ? jsonEncode(metadata!.toJson()) : null,
    'scheduled_for': scheduledFor?.toIso8601String(),
    'expires_at': expiresAt?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class NotificationMetadata {
  String? image;
  String? sentBy;
  DateTime? sentAt;
  String? targetType;
  dynamic targetDetails;
  bool? pushNotification;
  String? pushService;
  int? recipientCount;

  NotificationMetadata({
    this.image,
    this.sentBy,
    this.sentAt,
    this.targetType,
    this.targetDetails,
    this.pushNotification,
    this.pushService,
    this.recipientCount,
  });

  factory NotificationMetadata.fromJson(Map<String, dynamic> json) {
    return NotificationMetadata(
      image: json['image'],
      sentBy: json['sentBy'],
      sentAt: DateTime.tryParse(json['sentAt'] ?? ''),
      targetType: json['targetType'],
      targetDetails: json['targetDetails'],
      pushNotification: json['pushNotification'],
      pushService: json['pushService'],
      recipientCount: json['recipientCount'],
    );
  }

  Map<String, dynamic> toJson() => {
    'image': image,
    'sentBy': sentBy,
    'sentAt': sentAt?.toIso8601String(),
    'targetType': targetType,
    'targetDetails': targetDetails,
    'pushNotification': pushNotification,
    'pushService': pushService,
    'recipientCount': recipientCount,
  };
}

class Pagination {
  int? total;
  int? current;
  int? totalPages;
  bool? hasMore;
  bool? fetchedAll;

  Pagination({
    this.total,
    this.current,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      current: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      fetchedAll: json['fetchedAll'],
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'currentPage': current,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };
}
