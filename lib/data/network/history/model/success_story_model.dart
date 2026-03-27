class BuyerSideResellerSuccessStoryResponse {
  final bool success;
  final String message;
  final BuyerSideResellerSuccessStoryData? data;

  BuyerSideResellerSuccessStoryResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BuyerSideResellerSuccessStoryResponse.fromJson(Map<String, dynamic> json) {
    return BuyerSideResellerSuccessStoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? BuyerSideResellerSuccessStoryData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
    };
  }
}

class BuyerSideResellerSuccessStoryData {
  final List<BuyerSideResellerSuccessStoryItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  BuyerSideResellerSuccessStoryData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory BuyerSideResellerSuccessStoryData.fromJson(Map<String, dynamic> json) {
    return BuyerSideResellerSuccessStoryData(
      items: (json['items'] as List?)
          ?.map((e) => BuyerSideResellerSuccessStoryItem.fromJson(e))
          .toList() ??
          [],
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((e) => e.toMap()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class BuyerSideResellerSuccessStoryItem {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String? resellerId;
  final String? title;
  final String? description;
  final String? achievement;
  final DateTime? monthYear;
  final int? totalDeals;
  final String? totalValue;
  final int? rating;
  final String? image;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BuyerSideResellerInfo? reseller;

  BuyerSideResellerSuccessStoryItem({
    required this.id,
    this.createdBy,
    this.updatedBy,
    this.resellerId,
    this.title,
    this.description,
    this.achievement,
    this.monthYear,
    this.totalDeals,
    this.totalValue,
    this.rating,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.reseller,
  });

  factory BuyerSideResellerSuccessStoryItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? date) {
      if (date == null || date.isEmpty) return null;
      try {
        return DateTime.parse(date);
      } catch (_) {
        return null;
      }
    }
    String? sanitizeUrl(String? url) {
      if (url == null) return null;
      return url.replaceAll('`', '').trim();
    }

    return BuyerSideResellerSuccessStoryItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      resellerId: json['resellerId'],
      title: json['title'],
      description: json['description'],
      achievement: json['achievement'],
      monthYear: parseDate(json['monthYear']),
      totalDeals: json['totalDeals'],
      totalValue: json['totalValue'],
      rating: json['rating'],
      image: sanitizeUrl(json['image']),
      status: json['status'],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      reseller: json['reseller'] != null
          ? BuyerSideResellerInfo.fromJson(json['reseller'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'resellerId': resellerId,
      'title': title,
      'description': description,
      'achievement': achievement,
      'monthYear': monthYear?.toIso8601String(),
      'totalDeals': totalDeals,
      'totalValue': totalValue,
      'rating': rating,
      'image': image,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'reseller': reseller?.toMap(),
    };
  }
}

class BuyerSideResellerInfo {
  final String id;
  final String username;
  final String userType;
  BuyerSideResellerInfo({
    required this.id,
    required this.username,
    required this.userType,
  });
  factory BuyerSideResellerInfo.fromJson(Map<String, dynamic> json) {
    return BuyerSideResellerInfo(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      userType: json['userType'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userType': userType,
    };
  }
}
