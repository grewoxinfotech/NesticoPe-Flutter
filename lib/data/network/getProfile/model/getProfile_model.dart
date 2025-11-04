class ResellerProfile {
  final bool success;
  final String message;
  final ResellerProfileData data;

  ResellerProfile({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResellerProfile.fromJson(Map<String, dynamic> json) {
    return ResellerProfile(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ResellerProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };

  Map<String, dynamic> toMap() => toJson();
}

class ResellerProfileData {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String userId;
  final int totalSales;
  final String totalCommissions;
  final String successRate;
  final int responseTime;
  final int currentAssignments;
  final List<dynamic> assignmentHistory;
  final String performanceLevel;
  final List<dynamic> specializations;
  final String createdAt;
  final String updatedAt;

  ResellerProfileData({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.userId,
    required this.totalSales,
    required this.totalCommissions,
    required this.successRate,
    required this.responseTime,
    required this.currentAssignments,
    required this.assignmentHistory,
    required this.performanceLevel,
    required this.specializations,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResellerProfileData.fromJson(Map<String, dynamic> json) {
    return ResellerProfileData(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      userId: json['userId'] ?? '',
      totalSales: json['totalSales'] ?? 0,
      totalCommissions: json['totalCommissions'] ?? '0.00',
      successRate: json['successRate'] ?? '0.00',
      responseTime: json['responseTime'] ?? 0,
      currentAssignments: json['currentAssignments'] ?? 0,
      assignmentHistory: List<dynamic>.from(json['assignmentHistory'] ?? []),
      performanceLevel: json['performanceLevel'] ?? '',
      specializations: List<dynamic>.from(json['specializations'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'userId': userId,
    'totalSales': totalSales,
    'totalCommissions': totalCommissions,
    'successRate': successRate,
    'responseTime': responseTime,
    'currentAssignments': currentAssignments,
    'assignmentHistory': assignmentHistory,
    'performanceLevel': performanceLevel,
    'specializations': specializations,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  Map<String, dynamic> toMap() => toJson();
}
