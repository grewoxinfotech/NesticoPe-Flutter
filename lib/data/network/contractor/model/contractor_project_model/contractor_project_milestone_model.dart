class ProjectMilestonesResponse {
  final bool success;
  final String message;
  final ProjectMilestonesData data;

  ProjectMilestonesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProjectMilestonesResponse.fromJson(Map<String, dynamic> json) {
    return ProjectMilestonesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProjectMilestonesData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProjectMilestonesData {
  final List<ProjectMilestone> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ProjectMilestonesData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ProjectMilestonesData.fromJson(Map<String, dynamic> json) {
    return ProjectMilestonesData(
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => ProjectMilestone.fromJson(e))
              .toList(),
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }
}

class ProjectMilestone {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? projectId;
  final String? title;
  final String? description;
  final String? milestoneType; // percentage | fixed
  final int? percentage;
  final String? milestoneAmount;
  final String? paidAmount;
  final String? remainingAmount;
  final String? paymentStatus; // pending | paid
  final String? workStatus; // not_started | in_progress | completed
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? completionDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProjectMilestone({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.projectId,
    this.title,
    this.description,
    this.milestoneType,
    this.percentage,
    this.milestoneAmount,
    this.paidAmount,
    this.remainingAmount,
    this.paymentStatus,
    this.workStatus,
    this.startDate,
    this.endDate,
    this.completionDate,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      projectId: json['projectId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      milestoneType: json['milestoneType'] ?? '',
      percentage: json['percentage'],
      milestoneAmount: json['milestoneAmount'] ?? '0.00',
      paidAmount: json['paidAmount'] ?? '0.00',
      remainingAmount: json['remainingAmount'] ?? '0.00',
      paymentStatus: json['paymentStatus'] ?? '',
      workStatus: json['workStatus'] ?? '',
      startDate:
          json['startDate'] != null
              ? DateTime.tryParse(json['startDate'])
              : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      completionDate:
          json['completionDate'] != null
              ? DateTime.tryParse(json['completionDate'])
              : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['id'] = id;
    if (createdBy != null) data['created_by'] = createdBy;
    if (updatedBy != null) data['updated_by'] = updatedBy;
    if (projectId != null) data['projectId'] = projectId;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (milestoneType != null) data['milestoneType'] = milestoneType;
    if (percentage != null) data['percentage'] = percentage;
    if (milestoneAmount != null) data['milestoneAmount'] = milestoneAmount;
    if (paidAmount != null) data['paidAmount'] = paidAmount;
    if (remainingAmount != null) data['remainingAmount'] = remainingAmount;
    if (paymentStatus != null) data['paymentStatus'] = paymentStatus;
    if (workStatus != null) data['workStatus'] = workStatus;
    if (startDate != null) data['startDate'] = startDate!.toIso8601String();
    if (endDate != null) data['endDate'] = endDate!.toIso8601String();
    if (completionDate != null) {
      data['completionDate'] = completionDate!.toIso8601String();
    }
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }
}
