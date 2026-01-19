import 'dart:convert';

/// Main API Response Model
class SearchHistoryResponse {
  final bool success;
  final String message;
  final SearchHistoryResponseData data;

  SearchHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SearchHistoryResponse.fromJson(Map<String, dynamic> json) {
    return SearchHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SearchHistoryResponseData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Inner Data Object
class SearchHistoryResponseData {
  final List<SearchHistory> item;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  SearchHistoryResponseData({
    required this.item,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory SearchHistoryResponseData.fromJson(Map<String, dynamic> json) {
    final list = json['items'];
    return SearchHistoryResponseData(
      item: list is List
          ? list.map((e) => SearchHistory.fromJson(e)).toList()
          : [],
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': item.map((e) => e.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

/// Individual Search History Item
class SearchHistory {
  final int id;
  final String userId;
  final List<String> keywords;
  final String searchedAt;
  final String createdAt;
  final String updatedAt;

  SearchHistory({
    required this.id,
    required this.userId,
    required this.keywords,
    required this.searchedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      keywords: _parseKeywords(json['keywords']),
      searchedAt: json['searchedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  static List<String> _parseKeywords(dynamic keywords) {
    if (keywords == null) return [];
    if (keywords is List) return keywords.cast<String>();
    if (keywords is String) {
      try {
        final decoded = jsonDecode(keywords);
        if (decoded is List) return decoded.cast<String>();
      } catch (_) {}
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'keywords': keywords,
      'searchedAt': searchedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
