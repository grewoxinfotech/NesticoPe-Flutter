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
  final List<AssignmentHistoryItem> assignmentHistory;
  final String performanceLevel;
  final Specializations? specializations;
  final String totalPlatformFeesGenerated;
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
    required this.totalPlatformFeesGenerated,
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
      totalCommissions: json['totalCommissions']?.toString() ?? '0.00',
      successRate: json['successRate']?.toString() ?? '0.00',
      responseTime: json['responseTime'] ?? 0,
      currentAssignments: json['currentAssignments'] ?? 0,
      assignmentHistory: (json['assignmentHistory'] as List? ?? [])
          .map((e) => AssignmentHistoryItem.fromJson(e))
          .toList(),
      performanceLevel: json['performanceLevel'] ?? '',
      specializations: _parseSpecializations(json['specializations']),
      totalPlatformFeesGenerated: json['totalPlatformFeesGenerated']?.toString() ?? '0.00',
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
    'assignmentHistory': assignmentHistory.map((e) => e.toJson()).toList(),
    'performanceLevel': performanceLevel,
    'specializations': specializations?.toJson(),
    'totalPlatformFeesGenerated': totalPlatformFeesGenerated,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  Map<String, dynamic> toMap() => toJson();
}

Specializations? _parseSpecializations(dynamic raw) {
  if (raw == null) return null;
  if (raw is Map<String, dynamic>) {
    return Specializations.fromJson(raw);
  }
  if (raw is List) {
    return Specializations(
      cities: const [],
      propertyTypes: raw.map((e) => e.toString()).toList(),
      priceRanges: PriceRanges(),
    );
  }
  return null;
}

class Specializations {
  final List<String> cities;
  final List<String> propertyTypes;
  final PriceRanges priceRanges;

  Specializations({
    required this.cities,
    required this.propertyTypes,
    required this.priceRanges,
  });

  factory Specializations.fromJson(Map<String, dynamic> json) {
    return Specializations(
      cities: (json['cities'] as List? ?? []).map((e) => e.toString()).toList(),
      propertyTypes:
          (json['propertyTypes'] as List? ?? []).map((e) => e.toString()).toList(),
      priceRanges: PriceRanges.fromJson(json['priceRanges'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'cities': cities,
        'propertyTypes': propertyTypes,
        'priceRanges': priceRanges.toJson(),
      };
}

class PriceRanges {
  final num? min;
  final num? max;
  final num? avg;

  PriceRanges({this.min, this.max, this.avg});

  factory PriceRanges.fromJson(Map<String, dynamic> json) {
    return PriceRanges(
      min: _toNum(json['min']),
      max: _toNum(json['max']),
      avg: _toNum(json['avg']),
    );
  }

  Map<String, dynamic> toJson() => {
        'min': min,
        'max': max,
        'avg': avg,
      };
}

num? _toNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  if (v is String) {
    return num.tryParse(v);
  }
  return null;
}

class AssignmentHistoryItem {
  final String status;
  final String assignedAt;
  final String propertyId;

  AssignmentHistoryItem({
    required this.status,
    required this.assignedAt,
    required this.propertyId,
  });

  factory AssignmentHistoryItem.fromJson(Map<String, dynamic> json) {
    return AssignmentHistoryItem(
      status: json['status'] ?? '',
      assignedAt: json['assignedAt'] ?? '',
      propertyId: json['propertyId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'assignedAt': assignedAt,
    'propertyId': propertyId,
  };
}
