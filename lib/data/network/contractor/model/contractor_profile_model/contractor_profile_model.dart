class TopContractorsResponse {
  final bool success;
  final String message;
  final TopContractorData data;

  TopContractorsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TopContractorsResponse.fromJson(Map<String, dynamic> json) {
    return TopContractorsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TopContractorData.fromJson(json['data'] ?? {}),
    );
  }
}

class TopContractorData {
  final List<Contractor> items;
  final Pagination pagination;

  TopContractorData({required this.items, required this.pagination});

  factory TopContractorData.fromJson(Map<String, dynamic> json) {
    return TopContractorData(
      items:
          (json['items'] as List? ?? [])
              .map((x) => Contractor.fromJson(x))
              .toList(),
      pagination: Pagination.fromJson(json),
    );
  }
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
      total: TypeConverter.parseInt(json['total']),
      current: TypeConverter.parseInt(json['currentPage']),
      totalPages: TypeConverter.parseInt(json['totalPages']),
      hasMore: json['hasMore'] as bool?,
      fetchedAll: json['fetchedAll'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'current': current,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };
}

class Contractor {
  final String id;
  final String userId;
  final int totalReviews;
  final String overallRating;
  final int totalServices;
  final int activeServices;
  final String username;
  final int totalExperience;
  final ProjectStats projectStats;
  final Subscription subscription;

  Contractor({
    required this.id,
    required this.userId,
    required this.totalReviews,
    required this.overallRating,
    required this.totalServices,
    required this.activeServices,
    required this.username,
    required this.totalExperience,
    required this.projectStats,
    required this.subscription,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      totalReviews: json['totalReviews'] ?? 0,
      overallRating: json['overallRating']?.toString() ?? "0",
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      username: json['username'] ?? '',
      totalExperience: json['totalExperience'] ?? 0,
      projectStats: ProjectStats.fromJson(json['projectStats'] ?? {}),
      subscription: Subscription.fromJson(json['subscription'] ?? {}),
    );
  }
}

class ProjectStats {
  final int totalProjects;
  final int pendingProjects;
  final int inProgressProjects;
  final int completedProjects;
  final int cancelledProjects;

  ProjectStats({
    required this.totalProjects,
    required this.pendingProjects,
    required this.inProgressProjects,
    required this.completedProjects,
    required this.cancelledProjects,
  });

  factory ProjectStats.fromJson(Map<String, dynamic> json) {
    return ProjectStats(
      totalProjects: json['totalProjects'] ?? 0,
      pendingProjects: json['pendingProjects'] ?? 0,
      inProgressProjects: json['inProgressProjects'] ?? 0,
      completedProjects: json['completedProjects'] ?? 0,
      cancelledProjects: json['cancelledProjects'] ?? 0,
    );
  }
}

class Subscription {
  final bool hasPremiumPlan;
  final int planAmount;
  final String? planName;

  Subscription({
    required this.hasPremiumPlan,
    required this.planAmount,
    this.planName,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      hasPremiumPlan: json['hasPremiumPlan'] ?? false,
      planAmount: json['planAmount'] ?? 0,
      planName: json['planName'],
    );
  }
}

class TypeConverter {
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
