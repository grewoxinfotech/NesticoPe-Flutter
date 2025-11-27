class ResellerFakeLeadStatsResponse {
  final bool success;
  final String message;
  final ResellerFakeLeadStatsData data;

  ResellerFakeLeadStatsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResellerFakeLeadStatsResponse.fromJson(Map<String, dynamic> json) {
    return ResellerFakeLeadStatsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ResellerFakeLeadStatsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class ResellerFakeLeadStatsData {
  final int totalFakeLeads;
  final int recentFakeLeads;
  final List<FakeLeadHistory> fakeLeadHistory;
  final List<BlockHistory> blockHistory;
  final bool isCurrentlyBlocked;
  final dynamic currentBlock;
  final int warningThreshold;
  final int blockThreshold;
  final int remainingWarnings;
  final int remainingBeforeBlock;

  ResellerFakeLeadStatsData({
    required this.totalFakeLeads,
    required this.recentFakeLeads,
    required this.fakeLeadHistory,
    required this.blockHistory,
    required this.isCurrentlyBlocked,
    required this.currentBlock,
    required this.warningThreshold,
    required this.blockThreshold,
    required this.remainingWarnings,
    required this.remainingBeforeBlock,
  });

  factory ResellerFakeLeadStatsData.fromJson(Map<String, dynamic> json) {
    return ResellerFakeLeadStatsData(
      totalFakeLeads: json['totalFakeLeads'] ?? 0,
      recentFakeLeads: json['recentFakeLeads'] ?? 0,
      fakeLeadHistory:
          (json['fakeLeadHistory'] as List<dynamic>?)
              ?.map((e) => FakeLeadHistory.fromJson(e))
              .toList() ??
          [],
      blockHistory:
          (json['blockHistory'] as List<dynamic>?)
              ?.map((e) => BlockHistory.fromJson(e))
              .toList() ??
          [],
      isCurrentlyBlocked: json['isCurrentlyBlocked'] ?? false,
      currentBlock: json['currentBlock'],
      warningThreshold: json['warningThreshold'] ?? 0,
      blockThreshold: json['blockThreshold'] ?? 0,
      remainingWarnings: json['remainingWarnings'] ?? 0,
      remainingBeforeBlock: json['remainingBeforeBlock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalFakeLeads': totalFakeLeads,
    'recentFakeLeads': recentFakeLeads,
    'fakeLeadHistory': fakeLeadHistory.map((e) => e.toJson()).toList(),
    'blockHistory': blockHistory.map((e) => e.toJson()).toList(),
    'isCurrentlyBlocked': isCurrentlyBlocked,
    'currentBlock': currentBlock,
    'warningThreshold': warningThreshold,
    'blockThreshold': blockThreshold,
    'remainingWarnings': remainingWarnings,
    'remainingBeforeBlock': remainingBeforeBlock,
  };
}

class FakeLeadHistory {
  final String id;
  final DateTime markedFakeAt;
  final String reason;

  FakeLeadHistory({
    required this.id,
    required this.markedFakeAt,
    required this.reason,
  });

  factory FakeLeadHistory.fromJson(Map<String, dynamic> json) {
    return FakeLeadHistory(
      id: json['id'] ?? '',
      markedFakeAt:
          DateTime.tryParse(json['markedFakeAt'] ?? '') ?? DateTime.now(),
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'markedFakeAt': markedFakeAt.toIso8601String(),
    'reason': reason,
  };
}

class BlockHistory {
  final DateTime? startDate;
  final DateTime? endDate;
  final String reason;
  final String blockType;
  final String status;
  final bool isActive;

  BlockHistory({
    this.startDate,
    this.endDate,
    required this.reason,
    required this.blockType,
    required this.status,
    required this.isActive,
  });

  factory BlockHistory.fromJson(Map<String, dynamic> json) {
    return BlockHistory(
      startDate:
          json['startDate'] != null
              ? DateTime.tryParse(json['startDate'])
              : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      reason: json['reason'] ?? '',
      blockType: json['blockType'] ?? '',
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'reason': reason,
    'blockType': blockType,
    'status': status,
    'isActive': isActive,
  };
}
