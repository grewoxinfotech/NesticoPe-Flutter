class PaginationMeta {
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  PaginationMeta({
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class PaginationResponse<T> {
  final List<T> items;
  final PaginationMeta meta;

  PaginationResponse({required this.items, required this.meta});

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonModel,
  ) {
    final data = json['data'] ?? {};
    final itemsJson =
        (data['items'] as List?) ?? (data['properties'] as List?) ?? [];

    final itemsList = itemsJson.map((i) => fromJsonModel(i)).toList();

    return PaginationResponse(
      items: itemsList,
      meta: PaginationMeta.fromJson(data),
    );
  }

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T model) toJsonModel,
  ) {
    return {
      'items': items.map((e) => toJsonModel(e)).toList(),
      'meta': meta.toJson(),
    };
  }
}
