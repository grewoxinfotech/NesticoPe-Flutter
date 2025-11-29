class ApprovalHistoryResponse {
  final bool success;
  final String message;
  final List<ApprovalHistory> data;

  ApprovalHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApprovalHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ApprovalHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<ApprovalHistory>.from(
                json['data'].map((x) => ApprovalHistory.fromJson(x)),
              )
              : [],
    );
  }
}

class ApprovalHistory {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String propertyId;
  final String adminUserId;
  final String adminName;
  final String action;
  final String? reason;
  final String? document;
  final String previousStatus;
  final String newStatus;
  final DateTime actionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApprovalHistory({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.propertyId,
    required this.adminUserId,
    required this.adminName,
    required this.action,
    this.reason,
    this.document,
    required this.previousStatus,
    required this.newStatus,
    required this.actionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApprovalHistory.fromJson(Map<String, dynamic> json) {
    return ApprovalHistory(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      propertyId: json['propertyId'] ?? '',
      adminUserId: json['adminUserId'] ?? '',
      adminName: json['adminName'] ?? '',
      action: json['action'] ?? '',
      reason: json['reason'],
      document: json['document'],
      previousStatus: json['previousStatus'] ?? '',
      newStatus: json['newStatus'] ?? '',
      actionDate: DateTime.parse(json['actionDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
