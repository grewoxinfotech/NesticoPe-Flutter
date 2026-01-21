class ContractorLeadFollowupModel {
  final bool success;
  final String message;
  final ContractorLeadFollowUpData data;

  ContractorLeadFollowupModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorLeadFollowupModel.fromJson(Map<String, dynamic> json) {
    return ContractorLeadFollowupModel(
      success: json['success'],
      message: json['message'],
      data: ContractorLeadFollowUpData.fromJson(json['data']),
    );
  }

  /// Convert model to Map
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data.toMap(),
    };
  }
}

class ContractorLeadFollowUpData {
  final List<ContractorLeadFollowUpItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ContractorLeadFollowUpData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorLeadFollowUpData.fromJson(Map<String, dynamic> json) {
    return ContractorLeadFollowUpData(
      items: (json['items'] as List)
          .map((item) => ContractorLeadFollowUpItem.fromJson(item))
          .toList(),
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      fetchedAll: json['fetchedAll'],
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class ContractorLeadFollowUpItem {
  final String id;
  final String type;
  final String? date;
  final String? time;
  final String? notes;
  final String? status;
  final bool reminder;
  final String? location;
  final String? createdAt;

  ContractorLeadFollowUpItem({
    required this.id,
    required this.type,
    this.date,
    this.time,
    this.notes,
    this.status,
    required this.reminder,
    this.location,
    this.createdAt,
  });

  factory ContractorLeadFollowUpItem.fromJson(Map<String, dynamic> json) {
    return ContractorLeadFollowUpItem(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      date: json['date'],
      time: json['time'],
      notes: json['notes'],
      status: json['status'],
      reminder: json['reminder'] ?? false,
      location: json['location'],
      createdAt: json['createdAt'],
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'date': date,
      'time': time,
      'notes': notes,
      'status': status,
      'reminder': reminder,
      'location': location,
      'createdAt': createdAt,
    };
  }
}
