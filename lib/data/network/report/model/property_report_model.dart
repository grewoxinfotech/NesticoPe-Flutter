class PropertyReportModel {
  final String propertyId;
  final String reason;
  final String description;

  PropertyReportModel({
    required this.propertyId,
    required this.reason,
    required this.description,
  });

  /// Convert JSON to Model
  factory PropertyReportModel.fromJson(Map<String, dynamic> json) {
    return PropertyReportModel(
      propertyId: json['propertyId'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'reason': reason,
      'description': description,
    };
  }
}

class PropertyReportItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? propertyId;
  final String? reportedBy;
  final String? reason;
  final String? description;
  final String? status;
  final String? reviewedBy;
  final String? reviewedAt;
  final String? reviewNotes;
  final String? createdAt;
  final String? updatedAt;

  PropertyReportItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.propertyId,
    this.reportedBy,
    this.reason,
    this.description,
    this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory PropertyReportItem.fromJson(Map<String, dynamic> json) {
    return PropertyReportItem(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      propertyId: json['propertyId'],
      reportedBy: json['reportedBy'],
      reason: json['reason'],
      description: json['description'],
      status: json['status'],
      reviewedBy: json['reviewedBy'],
      reviewedAt: json['reviewedAt'],
      reviewNotes: json['reviewNotes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'propertyId': propertyId,
      'reportedBy': reportedBy,
      'reason': reason,
      'description': description,
      'status': status,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
      'reviewNotes': reviewNotes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
