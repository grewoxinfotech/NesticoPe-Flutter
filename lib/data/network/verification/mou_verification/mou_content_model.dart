class MouResponse {
  final bool? success;
  final String? message;
  final MouData? data;

  MouResponse({
    this.success,
    this.message,
    this.data,
  });

  factory MouResponse.fromJson(Map<String, dynamic> json) {
    return MouResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? MouData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class MouData {
  final List<MouItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  MouData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory MouData.fromJson(Map<String, dynamic> json) {
    return MouData(
      items: (json['items'] as List?)
    ?.map(
      (e) => MouItem.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
    .toList(),
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      fetchedAll: json['fetchedAll'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class MouItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MouItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory MouItem.fromJson(Map<String, dynamic> json) {
    return MouItem(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'title': title,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}