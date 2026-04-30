class ContractorActiveSubscriptionResponse {
  final bool success;
  final String message;
  final ContractorActiveSubscriptionData? data;

  ContractorActiveSubscriptionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorActiveSubscriptionResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ContractorActiveSubscriptionResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data:
          json['data'] == null
              ? null
              : ContractorActiveSubscriptionData.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
    );
  }
}

class ContractorActiveSubscriptionData {
  final Map<String, dynamic>? metadata;
  final int usedServices;
  final int usedLeads;
  final int usedUsers;
  final String? status;

  ContractorActiveSubscriptionData({
    required this.metadata,
    required this.usedServices,
    required this.usedLeads,
    required this.usedUsers,
    required this.status,
  });

  factory ContractorActiveSubscriptionData.fromJson(Map<String, dynamic> json) {
    return ContractorActiveSubscriptionData(
      metadata: json['metadata'] as Map<String, dynamic>?,
      usedServices: _toInt(json['usedServices']),
      usedLeads: _toInt(json['usedLeads']),
      usedUsers: _toInt(json['usedUsers']),
      status: json['status']?.toString(),
    );
  }

  int get maxServices => _toInt(metadata?['maxServices']);
  int get maxLeads => _toInt(metadata?['maxLeads']);
  int get maxUsers => _toInt(metadata?['maxUsers']);

  bool get isServiceLimitReached => maxServices > 0 && usedServices >= maxServices;
  bool get isLeadLimitReached => maxLeads > 0 && usedLeads >= maxLeads;
  bool get isUserLimitReached => maxUsers > 0 && usedUsers >= maxUsers;

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
