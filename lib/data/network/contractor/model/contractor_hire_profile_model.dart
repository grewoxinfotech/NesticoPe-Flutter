
class HireContractorUserProfileResponse {
  final bool success;
  final String message;
  final List<HireContractorUserProfile> profiles;
  final int count;

  HireContractorUserProfileResponse({
    required this.success,
    required this.message,
    required this.profiles,
    required this.count,
  });

  factory HireContractorUserProfileResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'] ?? {};
    final profiles = (data['profiles'] as List<dynamic>?)
        ?.map((e) => HireContractorUserProfile.fromMap(e))
        .toList() ??
        [];

    return HireContractorUserProfileResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      profiles: profiles,
      count: data['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': {
        'count': count,
        'profiles': profiles.map((e) => e.toMap()).toList(),
      },
    };
  }
}


class HireContractorUserProfile {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String userId;
  final int totalReviews;
  final String overallRating;
  final int warningCount;
  final int totalServices;
  final bool isBlocked;
  final String? blockReason;
  final String? blockedAt;
  final int activeServices;
  final DateTime createdAt;
  final DateTime updatedAt;

  HireContractorUserProfile({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.userId,
    required this.totalReviews,
    required this.overallRating,
    required this.warningCount,
    required this.totalServices,
    required this.isBlocked,
    this.blockReason,
    this.blockedAt,
    required this.activeServices,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ✅ Create from Map
  factory HireContractorUserProfile.fromMap(Map<String, dynamic> map) {
    return HireContractorUserProfile(
      id: map['id'] ?? '',
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      userId: map['userId'] ?? '',
      totalReviews: map['totalReviews'] ?? 0,
      overallRating: map['overallRating'] ?? '0.00',
      warningCount: map['warningCount'] ?? 0,
      totalServices: map['totalServices'] ?? 0,
      isBlocked: map['isBlocked'] ?? false,
      blockReason: map['blockReason'],
      blockedAt: map['blockedAt'],
      activeServices: map['activeServices'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  /// ✅ Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'userId': userId,
      'totalReviews': totalReviews,
      'overallRating': overallRating,
      'warningCount': warningCount,
      'totalServices': totalServices,
      'isBlocked': isBlocked,
      'blockReason': blockReason,
      'blockedAt': blockedAt,
      'activeServices': activeServices,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// ✅ From JSON
  factory HireContractorUserProfile.fromJson(Map<String, dynamic> json) =>
      HireContractorUserProfile.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}
