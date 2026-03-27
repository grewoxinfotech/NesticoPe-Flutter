class TopCategoryResponse {
  final bool success;
  final String message;
  final TopCategoryData? data;

  TopCategoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory TopCategoryResponse.fromJson(Map<String, dynamic> json) {
    return TopCategoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? TopCategoryData.fromJson(json['data'])
          : null,
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

class TopCategoryData {
  final List<TopCategoryItem> items;
  final int total;

  TopCategoryData({
    required this.items,
    required this.total,
  });

  factory TopCategoryData.fromJson(Map<String, dynamic> json) {
    return TopCategoryData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => TopCategoryItem.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}

class TopCategoryItem {
  final String id;
  final String createdBy;
  final String? updatedBy;
  final String name;
  final List<String> description;
  final String? icon;
  final int isActive;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serviceCount;
  final int totalReviews;
  final double averageRating;

  TopCategoryItem({
    required this.id,
    required this.createdBy,
    this.updatedBy,
    required this.name,
    required this.description,
    required this.isActive,
    this.icon,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceCount,
    required this.totalReviews,
    required this.averageRating,
  });

  factory TopCategoryItem.fromJson(Map<String, dynamic> json) {
    return TopCategoryItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      name: json['name'] ?? '',
      icon: json['icon']??'',
      description: List<String>.from(json['description'] ?? []),
      isActive: json['isActive'] ?? 0,
      displayOrder: json['displayOrder'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      serviceCount: json['serviceCount'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      averageRating:
      (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'name': name,
      'icon':icon,
      'description': description,
      'isActive': isActive,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'serviceCount': serviceCount,
      'totalReviews': totalReviews,
      'averageRating': averageRating,
    };
  }
}
