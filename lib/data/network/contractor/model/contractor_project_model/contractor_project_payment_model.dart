// class MilestonePaymentsResponse {
//   final bool success;
//   final String message;
//   final MilestonePaymentsData data;
//
//   MilestonePaymentsResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory MilestonePaymentsResponse.fromJson(Map<String, dynamic> json) {
//     return MilestonePaymentsResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: MilestonePaymentsData.fromJson(json['data'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data.toJson(),
//     };
//   }
// }
//
// class MilestonePaymentsData {
//   final List<MilestonePaymentItem> items;
//   final int total;
//   final int currentPage;
//   final int totalPages;
//   final bool hasMore;
//   final bool fetchedAll;
//
//   MilestonePaymentsData({
//     required this.items,
//     required this.total,
//     required this.currentPage,
//     required this.totalPages,
//     required this.hasMore,
//     required this.fetchedAll,
//   });
//
//   factory MilestonePaymentsData.fromJson(Map<String, dynamic> json) {
//     return MilestonePaymentsData(
//       items: (json['items'] as List? ?? [])
//           .map((e) => MilestonePaymentItem.fromJson(e))
//           .toList(),
//       total: json['total'] ?? 0,
//       currentPage: json['currentPage'] ?? 0,
//       totalPages: json['totalPages'] ?? 0,
//       hasMore: json['hasMore'] ?? false,
//       fetchedAll: json['fetchedAll'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'items': items.map((e) => e.toJson()).toList(),
//       'total': total,
//       'currentPage': currentPage,
//       'totalPages': totalPages,
//       'hasMore': hasMore,
//       'fetchedAll': fetchedAll,
//     };
//   }
// }
//
// class MilestonePaymentItem {
//   final String id;
//   final String? createdBy;
//   Null updatedBy;
//   final String? milestoneId;
//   final String? projectId;
//   final String? amount;
//   final String? paymentMode;
//   final String? referenceNote;
//   final String? paymentStatus;
//   final DateTime paidOn;
//   final DateTime? createdAt;
//          // ✅ made nullable
//   final DateTime? updatedAt;
//   final Milestone milestone;
//
//   MilestonePaymentItem({
//     required this.id,
//      this.createdBy,
//      this.updatedBy,
//
//     required this.milestoneId,
//     required this.projectId,
//     required this.amount,
//     required this.paymentMode,
//      this.referenceNote,
//     required this.paymentStatus,
//     required this.paidOn,
//      this.createdAt,
//      this.updatedAt,
//     required this.milestone,
//   });
//
//   factory MilestonePaymentItem.fromJson(Map<String, dynamic> json) {
//     return MilestonePaymentItem(
//       id: json['id'] ?? '',
//       createdBy: json['created_by'] ?? '',
//       updatedBy: json['updated_by'] ,
//       milestoneId: json['milestoneId'] ?? '',
//       projectId: json['projectId'] ?? '',
//
//       amount: json['amount'] ?? '0.00',
//       paymentMode: json['paymentMode'] ?? '',
//       referenceNote: json['referenceNote'] ?? '',
//       paymentStatus: json['paymentStatus'] ?? '',
//       paidOn: DateTime.parse(json['paidOn']),
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       milestone: Milestone.fromJson(json['milestone'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'created_by': createdBy,
//       'updated_by': updatedBy,
//       'milestoneId': milestoneId,
//       'projectId': projectId,
//       'amount': amount,
//       'paymentMode': paymentMode,
//       'referenceNote': referenceNote,
//       'paymentStatus': paymentStatus,
//
//       'paidOn': paidOn.toIso8601String(),
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       'milestone': milestone.toJson(),
//     };
//   }
// }
//
// class Milestone {
//   final String id;
//   final String? createdBy;
//   Null updatedBy;
//   final String projectId;
//   final String title;
//   final String description;
//   final String milestoneType;
//   final int percentage;
//   final String milestoneAmount;
//   final String paidAmount;
//   final String remainingAmount;
//   final DateTime? startDate;       // ✅ made nullable
//   final DateTime? endDate;
//   final String paymentStatus;
//   final String workStatus;
//
//   final DateTime? completionDate;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   Milestone({
//     required this.id,
//      this.createdBy,
//      this.updatedBy,
//     this.startDate,
//     this.endDate,
//     required this.projectId,
//     required this.title,
//     required this.description,
//     required this.milestoneType,
//     required this.percentage,
//     required this.milestoneAmount,
//     required this.paidAmount,
//     required this.remainingAmount,
//     required this.paymentStatus,
//     required this.workStatus,
//
//      this.completionDate,
//      this.createdAt,
//      this.updatedAt,
//   });
//
//   factory Milestone.fromJson(Map<String, dynamic> json) {
//     return Milestone(
//       id: json['id'] ?? '',
//       createdBy: json['created_by'] ?? '',
//       updatedBy: json['updated_by'],
//       projectId: json['projectId'] ?? '',
//       title: json['title'] ?? '',
//       startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
//       endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
//       description: json['description'] ?? '',
//       milestoneType: json['milestoneType'] ?? '',
//       percentage: json['percentage'] ?? 0,
//       milestoneAmount: json['milestoneAmount'] ?? '0.00',
//       paidAmount: json['paidAmount'] ?? '0.00',
//       remainingAmount: json['remainingAmount'] ?? '0.00',
//       paymentStatus: json['paymentStatus'] ?? '',
//       workStatus: json['workStatus'] ?? '',
//
//       completionDate: json['completionDate'] == null
//           ? null
//           : DateTime.parse(json['completionDate']) ,
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'created_by': createdBy,
//       'updated_by': updatedBy,
//       'projectId': projectId,
//       'title': title,
//       'description': description,
//       'milestoneType': milestoneType,
//       'percentage': percentage,
//       'milestoneAmount': milestoneAmount,
//       'paidAmount': paidAmount,
//       'remainingAmount': remainingAmount,
//       'paymentStatus': paymentStatus,
//       'workStatus': workStatus,
//       'startDate': startDate?.toIso8601String(),
//       'endDate': endDate?.toIso8601String(),
//       'completionDate': completionDate?.toIso8601String(),
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }

import 'dart:developer';

class MilestonePaymentsResponse {
  final bool success;
  final String message;
  final MilestonePaymentsData data;

  MilestonePaymentsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MilestonePaymentsResponse.fromJson(Map<String, dynamic> json) {
    return MilestonePaymentsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MilestonePaymentsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MilestonePaymentsData {
  final List<MilestonePaymentItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  MilestonePaymentsData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory MilestonePaymentsData.fromJson(Map<String, dynamic> json) {
    return MilestonePaymentsData(
      items: (json['items'] as List? ?? [])
          .map((e) => MilestonePaymentItem.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class MilestonePaymentItem {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String? milestoneId;
  final String? projectId;
  final String? amount;
  final String? paymentMode;
  final String? referenceNote;
  final String? paymentStatus;
  final DateTime? paidOn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Milestone milestone;

  MilestonePaymentItem({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.milestoneId,
    required this.projectId,
    required this.amount,
    required this.paymentMode,
    this.referenceNote,
    required this.paymentStatus,
    this.paidOn,
    this.createdAt,
    this.updatedAt,
    required this.milestone,
  });

  factory MilestonePaymentItem.fromJson(Map<String, dynamic> json) {
    return MilestonePaymentItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      milestoneId: json['milestoneId'],
      projectId: json['projectId'],
      amount: json['amount'] ?? '0.00',
      paymentMode: json['paymentMode'] ?? '',
      referenceNote: json['referenceNote'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      paidOn: _tryParseDate(json['paidOn']),
      createdAt: _tryParseDate(json['createdAt']),
      updatedAt: _tryParseDate(json['updatedAt']),
      milestone: Milestone.fromJson(json['milestone'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'milestoneId': milestoneId,
      'projectId': projectId,
      'amount': amount,
      'paymentMode': paymentMode,
      'referenceNote': referenceNote,
      'paymentStatus': paymentStatus,
      'paidOn': paidOn?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'milestone': milestone.toJson(),
    };
  }
}

class Milestone {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String projectId;
  final String title;
  final String description;
  final String milestoneType;
  final int? percentage;
  final String milestoneAmount;
  final String paidAmount;
  final String remainingAmount;
  final String paymentStatus;
  final String workStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? completionDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Milestone({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.projectId,
    required this.title,
    required this.description,
    required this.milestoneType,
    this.percentage,
    required this.milestoneAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.paymentStatus,
    required this.workStatus,
    this.startDate,
    this.endDate,
    this.completionDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      projectId: json['projectId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      milestoneType: json['milestoneType'] ?? '',
      percentage: json['percentage'], // can be null
      milestoneAmount: json['milestoneAmount'] ?? '0.00',
      paidAmount: json['paidAmount'] ?? '0.00',
      remainingAmount: json['remainingAmount'] ?? '0.00',
      paymentStatus: json['paymentStatus'] ?? '',
      workStatus: json['workStatus'] ?? '',
      startDate: _tryParseDate(json['startDate']),
      endDate: _tryParseDate(json['endDate']),
      completionDate: _tryParseDate(json['completionDate']),
      createdAt: _tryParseDate(json['createdAt']),
      updatedAt: _tryParseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'projectId': projectId,
      'title': title,
      'description': description,
      'milestoneType': milestoneType,
      'percentage': percentage,
      'milestoneAmount': milestoneAmount,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'paymentStatus': paymentStatus,
      'workStatus': workStatus,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// ✅ Helper for safely parsing DateTime
DateTime? _tryParseDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value.toString());
  } catch (e) {
    log('⚠️ Invalid date format: $value');
    return null;
  }
}

