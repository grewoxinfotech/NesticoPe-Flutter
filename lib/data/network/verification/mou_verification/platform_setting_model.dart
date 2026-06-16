class PlatformFeeResponse {
  final bool? success;
  final String? message;
  final PlatformFeeData? data;

  PlatformFeeResponse({
    this.success,
    this.message,
    this.data,
  });

  factory PlatformFeeResponse.fromJson(Map<String, dynamic> json) {
    return PlatformFeeResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? PlatformFeeData.fromJson(json['data'])
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

class PlatformFeeData {
  final List<PlatformFeeItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  PlatformFeeData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory PlatformFeeData.fromJson(Map<String, dynamic> json) {
    return PlatformFeeData(
      items: (json['items'] as List?)
          ?.map((e) => PlatformFeeItem.fromJson(e))
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

class PlatformFeeItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? category;
  final String? percentage;
  final String? calculationType;
  final String? amount;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlatformFeeItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.category,
    this.percentage,
    this.calculationType,
    this.amount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PlatformFeeItem.fromJson(Map<String, dynamic> json) {
    return PlatformFeeItem(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      category: json['category'],
      percentage: json['percentage'],
      calculationType: json['calculationType'],
      amount: json['amount'],
      isActive: json['isActive'],
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
      'category': category,
      'percentage': percentage,
      'calculationType': calculationType,
      'amount': amount,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}