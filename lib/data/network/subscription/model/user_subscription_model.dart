class CurrentUserSubscription {
  final bool success;
  final String message;
  final SCurrentUserSubscriptionData? data;

  CurrentUserSubscription({
    required this.success,
    required this.message,
    this.data,
  });

  factory CurrentUserSubscription.fromJson(Map<String, dynamic> json) {
    return CurrentUserSubscription(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? SCurrentUserSubscriptionData.fromJson(
                Map<String, dynamic>.from(json['data']),
              )
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {'success': success, 'message': message, 'data': data?.toMap()};
  }
}

class SCurrentUserSubscriptionData {
  final List<CurrentUserSubscriptionItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  SCurrentUserSubscriptionData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory SCurrentUserSubscriptionData.fromJson(Map<String, dynamic> json) {
    return SCurrentUserSubscriptionData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => CurrentUserSubscriptionItem.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
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

class CurrentUserSubscriptionItem {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String? userId;
  final String? planId;
  final String? amount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final bool autoRenew;
  final bool isPremium;
  final Map<String, dynamic>? metadata;
  final int usedProperties;
  final int usedServices;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CurrentUserPlan? plan;
  final CurrentUserData? user;

  CurrentUserSubscriptionItem({
    required this.id,
    this.createdBy,
    this.updatedBy,
    this.userId,
    this.planId,
    this.amount,
    this.startDate,
    this.endDate,
    this.status,
    this.autoRenew = false,
    this.isPremium = false,
    this.metadata,
    this.usedProperties = 0,
    this.usedServices = 0,
    this.createdAt,
    this.updatedAt,
    this.plan,
    this.user,
  });

  factory CurrentUserSubscriptionItem.fromJson(Map<String, dynamic> json) {
    return CurrentUserSubscriptionItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      userId: json['userId'],
      planId: json['planId'],
      amount: json['amount']?.toString(),
      startDate:
          json['startDate'] != null
              ? DateTime.tryParse(json['startDate'])
              : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      status: json['status'],
      autoRenew: json['autoRenew'] ?? false,
      isPremium: json['isPremium'] ?? false,
      metadata:
          json['metadata'] is Map
              ? Map<String, dynamic>.from(json['metadata'])
              : null,
      usedProperties: json['usedProperties'] ?? 0,
      usedServices: json['usedServices'] ?? 0,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      plan:
          json['plan'] != null
              ? CurrentUserPlan.fromJson(
                Map<String, dynamic>.from(json['plan']),
              )
              : null,
      user:
          json['user'] != null
              ? CurrentUserData.fromJson(
                Map<String, dynamic>.from(json['user']),
              )
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'userId': userId,
      'planId': planId,
      'amount': amount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'autoRenew': autoRenew,
      'isPremium': isPremium,
      'metadata': metadata,
      'usedProperties': usedProperties,
      'usedServices': usedServices,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'plan': plan?.toMap(),
      'user': user?.toMap(),
    };
  }
}

class CurrentUserPlan {
  final String? name;
  final String? type;
  final String? plansFor;
  final int? durationMonths;
  final String? amount;
  final bool? isPremium;
  final bool? isActive;
  final Map<String, dynamic>? features;

  CurrentUserPlan({
    this.name,
    this.type,
    this.plansFor,
    this.durationMonths,
    this.amount,
    this.isPremium,
    this.isActive,
    this.features,
  });

  factory CurrentUserPlan.fromJson(Map<String, dynamic> json) {
    return CurrentUserPlan(
      name: json['name'],
      type: json['type'],
      plansFor: json['plansFor'],
      durationMonths: json['durationMonths'],
      amount: json['amount']?.toString(),
      isPremium: json['isPremium'],
      isActive: json['isActive'],
      features:
          json['features'] is Map
              ? Map<String, dynamic>.from(json['features'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'plansFor': plansFor,
      'durationMonths': durationMonths,
      'amount': amount,
      'isPremium': isPremium,
      'isActive': isActive,
      'features': features,
    };
  }
}

class CurrentUserData {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? userType;

  CurrentUserData({
    this.username,
    this.firstName,
    this.lastName,
    this.userType,
  });

  factory CurrentUserData.fromJson(Map<String, dynamic> json) {
    return CurrentUserData(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'userType': userType,
    };
  }
}
