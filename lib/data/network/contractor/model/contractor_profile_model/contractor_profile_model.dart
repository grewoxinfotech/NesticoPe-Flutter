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
  String username;
  String firstName;
  String lastName;
  int totalExperience;
  final String imageUrl;
  ProjectStats projectStats;
  final String? contractorType;
  final Subscription subscription;
  final String? city;
  final String? state;
  final List<ServiceItem> services;

  Contractor({
    required this.imageUrl,
    required this.id,
    required this.userId,
    required this.totalReviews,
    required this.overallRating,
    required this.totalServices,
    required this.activeServices,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.totalExperience,
    required this.projectStats,
    this.contractorType,
    required this.subscription,
    this.city,
    this.state,
    this.services = const [],
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      imageUrl: json['profilePic'] ?? '',
      totalReviews: json['totalReviews'] ?? 0,
      overallRating: json['overallRating']?.toString() ?? "0",
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      totalExperience: json['totalExperience'] ?? 0,
      projectStats: ProjectStats.fromJson(json['projectData'] ?? {}),
      subscription: Subscription.fromJson(json['subscription'] ?? {}),
      contractorType: json['contractorType'] ?? null,
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      services: (json['services'] as List? ?? [])
          .map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'profilePic': imageUrl,
      'totalReviews': totalReviews,
      'overallRating': overallRating,
      'totalServices': totalServices,
      'activeServices': activeServices,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'totalExperience': totalExperience,
      'projectData': projectStats.toJson(),
      'subscription': subscription.toJson(),
      'contractorType': contractorType,
      'city': city,
      'state': state,
      'services': services.map((e) => e.toJson()).toList(),
    };
  }
}

class ProjectStats {
  int totalProjects;
  int pendingProjects;
  int inProgressProjects;
  int completedProjects;
  int cancelledProjects;

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

  Map<String, dynamic> toJson() {
    return {
      'totalProjects': totalProjects,
      'pendingProjects': pendingProjects,
      'inProgressProjects': inProgressProjects,
      'completedProjects': completedProjects,
      'cancelledProjects': cancelledProjects,
    };
  }
}

class Subscription {
  final bool hasPremiumPlan;
  final double planAmount;
  final String? planName;

  Subscription({
    required this.hasPremiumPlan,
    required this.planAmount,
    this.planName,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      hasPremiumPlan: json['hasPremiumPlan'] ?? false,
      planAmount: (json['planAmount'] is int)
          ? (json['planAmount'] as int).toDouble()
          : (json['planAmount'] is String)
              ? double.tryParse(json['planAmount']) ?? 0.0
              : (json['planAmount'] ?? 0).toDouble(),
      planName: json['planName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasPremiumPlan': hasPremiumPlan,
      'planAmount': planAmount,
      'planName': planName,
    };
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

class ServiceItem {
  final String id;
  final String serviceName;
  final String category;

  ServiceItem({
    required this.id,
    required this.serviceName,
    required this.category,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'category': category,
    };
  }
}
